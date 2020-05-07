//
//  NewViewController.swift
//  GreatImages
//
//  Created by Роман on 28.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit
import Kingfisher


class NewViewController: ImagesViewController {
    
    @IBOutlet weak var noConnectionImage: UIImageView!
    private let refreshControl = UIRefreshControl()
    let pickNewSegueIdentifier = "pickNewSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noConnectionImage.isHidden = true
        if !APIRouter.isConnectedToNetwork {
            noConnectionImage.isHidden = false
        }
        
        APIRouter.shared.fetchImages(page: 1, new: true, popular: false) {
            self.images = $0
        }
        
        navigationController?.navigationBar.isTranslucent = false
        
        // Сделал кастомный тайтл NavigationBar, так как не понимаю, как стандартный переместить
        let titleLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  New"
        titleLabel.textColor = UIColor.orange
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        navigationItem.titleView = titleLabel
        
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refreshImages(_:)), for: .valueChanged)
        
    }
    
    @objc func refreshImages(_ sender: Any) {
        
        if !APIRouter.isConnectedToNetwork {
            noConnectionImage.isHidden = false
        }
        else {
            noConnectionImage.isHidden = true
        }
        
        refreshControl.beginRefreshing()
        
        APIRouter.shared.fetchImages(page: 1, new: true, popular: false) {
            self.images = $0
        }
        pageNumber = 1
        
        self.refreshControl.endRefreshing()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == pickNewSegueIdentifier {
            
            let cell = sender as! ImageCell
            let DetailNewVC = segue.destination as! DetailViewController
            DetailNewVC.image = cell.imageView.image
            guard  let indexPath = collectionView.indexPath(for: cell) else { return }
            DetailNewVC.imageName = images[indexPath.item].name
            DetailNewVC.imageDescription = images[indexPath.item].description
            
        }
        
    }
    
    /*
     Не понял как сделать FooterView для CollectionView... Использовал отслеживание конца рабочей области.
     Делал класс и xib LoadingCell для того, чтобы ActivityIndicator поставить на подгрузку, но не получилось почему-то
     */
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if !fetchingMore {
                beginBatchFetch()
                self.pageNumber += 1
                fetchingMore = true
            }
        }
        
    }
    
    // Я полагаю, что растить массив - плохая практика, но другого решения не смог пока придумать
    // Вернее придумал. Подгружать данные для новых страниц, парочку, где-то хранить, а для предыдущих страниц удалять, но не понимаю как это делать(
    func beginBatchFetch() {
        
        DispatchQueue.main.async {
            APIRouter.shared.fetchImages(page: self.pageNumber, new: true, popular: false) {
                
                self.images.append(contentsOf: $0)
                self.fetchingMore = false
            }
        }
        
    }
    
    // MARK: UICollectionViewDataSource
    
    /*
     Возникли проблемы с кастом изображения с ответа на запрос API.
     Делал кучу всего, в итоге кастнул base64 к UIImage, пытался через Kingfisher, но возникли сложности с base64(на base64 был префикс, из-за которого не кастилось, а когда убирал, то все изображения были одинаковыми, хотя base64 коды грузились разные).
     Но я понимаю, что сделал плохо.. Потому что не кэширую данные и всегда новый запрос. Пытался, но безуспешно
     
     А еще обновляется таблица по запросу следующей страницы, тоже плохо наверно.
     Я должен был наверно Мне не хватило знаний, чтобы решить это(
     Наверно надо было по нескольку страниц грузить, предыдущую удалять, новую добавлять, хранить в памяти словарь id:indexpath.item, не знаю...
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.id, for: indexPath) as! ImageCell
        
        cell.tag = indexPath.item
        
        if !APIRouter.isConnectedToNetwork {
            
            noConnectionImage.alpha = 0
            collectionView.reloadData()
        }
        else {
            noConnectionImage.alpha = 1
            APIRouter.shared.fetchBase64(id: images[indexPath.item].imageID) { (base) in
                DispatchQueue.main.async {
                    if cell.tag == indexPath.item {
                        if let image = base!.base64ToImage() {
                            //cell.imageView.image = UIImage.resize(image)
                            cell.imageView.image = image
                        }
                    }
                }
            }
            cell.setStyle()
            return cell
        }
        return cell
    }
}
