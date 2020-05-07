//
//  ApiRouter.swift
//  GreatImages
//
//  Created by Роман on 24.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


class APIRouter {
    
    //Сделал статический инстанс, чтобы им пользоваться из других классов
    static var shared: APIRouter = APIRouter()
    
    // Везде смотрел пишут большие классы Reachability для проверки сети, но я решил, что через Alamofire будет удобно, так как его использую и так
    static var isConnectedToNetwork: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    //Решил не плодить код и сделал универсальную функцию для получения изображений по переданным параметрам
    func fetchImages(page: Int, new: Bool, popular: Bool, completion: @escaping ([ImageModel]) -> ()) {
        var url: String = "http://gallery.dev.webant.ru/api/photos?page=\(page)&limit=10"
        if new {
            url = "http://gallery.dev.webant.ru/api/photos?new=true&page=\(page)&limit=10"
        }
        else if popular {
            url = "http://gallery.dev.webant.ru/api/photos?popular=true&page=\(page)&limit=10"
        }
        else if !popular && !new {
            url = " "
        }
        var images: [ImageModel] = []
        
        //Здесь, обработав ответ заполняю массив моделей
        Alamofire.request(URL(string: url)!).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let JSON):
                
                let response = JSON as! Dictionary<String,Any>
                if let data = response["data"] as? NSArray {
                    for elem in data {
                        if let image = ImageMapper().map((elem as! [String : Any])) {
                            images.append(image)
                        }
                    }
                    completion(images)
                    
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    
    //Функция, которая вытаскивает base64 в строке по ID изображения с API
    func fetchBase64(id: Int, completion: @escaping (_ image: String?) -> ()) {
        
        let fileURL = "http://gallery.dev.webant.ru/api/media_objects/\(id)"
        Alamofire.request(URL(string: fileURL)!).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let JSON):
                let response = JSON as! Dictionary<String,Any>
                if let base64Image = response["file"] as? String {
                    completion(base64Image)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
            
        }
    }
    
    //Функция, которая конвертирует base64 строку в UIImage, который я и использую для ImageView
    func base64To(base64: String, completion: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let img = base64.base64ToImage()!
            DispatchQueue.main.async {
                completion(img)
            }
        }
        
    }
}
