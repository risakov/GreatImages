//
//  Image.swift
//  GreatImages
//
//  Created by Роман on 26.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import Foundation
import UIKit

struct ImageModel {
    
    let name: String
    let description: String
    let imageID: Int
    var base64: String = ""
    
    
    init(name: String, description: String, imageID: Int) {
        self.name = name
        self.description = description
        self.imageID = imageID
    }
    
    mutating func setBase(base64: String) {
        self.base64 = base64
    }
    
}

// Решил сделать класс для преобразования со словаря в модель
class ImageMapper {
    
    func map(_ dictionary: [String: Any]) -> ImageModel? {
        guard let imageData = dictionary["image"] as? Dictionary<String,Any> else { return nil }
        guard let imageID = imageData["id"] as? Int else { return nil }
        guard let name = dictionary["name"] as? String else { return nil }
        guard let description = dictionary["description"] as? String else { return nil }
        
        return ImageModel(name: name, description: description, imageID: imageID)
    }
    
}
