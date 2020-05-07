//
//  PopularViewController.swift
//  GreatImages
//
//  Created by Роман on 28.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit
import Kingfisher


// Этот экран работает, только я не понимаю почему он так долго инициализирует CollectionView((

class PopularViewController: ImagesViewController {
    
    @IBOutlet weak var noConnectionImage: UIImageView!
    private let refreshControl = UIRefreshControl()
    private let bottomRefreshController = UIRefreshControl()
    let pickPopularSegueIdentifier = "pickPopularSegue"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noConnectionImage.isHidden = true
        if !APIRouter.isConnectedToNetwork {
            noConnectionImage.isHidden = false
        }
        
        APIRouter.shared.fetchImages(page: 1, new: false, popular: true) {
            self.images = $0
        }
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Popular"
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
        APIRouter.shared.fetchImages(page: 1, new: false, popular: true) {
            self.images = $0
        }
        pageNumber = 1
        self.refreshControl.endRefreshing()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pickPopularSegueIdentifier {
            let cell = sender as! ImageCell
            let DetailNewVC = segue.destination as! DetailViewController
            DetailNewVC.image = cell.imageView.image
            guard  let indexPath = collectionView.indexPath(for: cell) else { return }
            DetailNewVC.imageName = images[indexPath.item].name
            DetailNewVC.imageDescription = images[indexPath.item].description
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if !fetchingMore {
                beginBatchFetch()
                self.pageNumber += 1
                fetchingMore = true
            }
        }
        
    }
    
    func beginBatchFetch() {
        
        collectionView.reloadSections(IndexSet(integer: 1))
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            APIRouter.shared.fetchImages(page: self.pageNumber, new: false, popular: true) { 
                self.images.append(contentsOf: $0)
                self.fetchingMore = false
            }
        })
        
    }
    
    // MARK: UICollectionViewDataSource
    
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
