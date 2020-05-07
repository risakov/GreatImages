//
//  ImagesViewController.swift
//  GreatImages
//
//  Created by Роман on 23.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit
import Kingfisher


// Я посчитал, что, чтобы не растить контроллер, я создам общий с общими функциями для почти идентичных и унаследуюсь с них от него

class ImagesViewController: UICollectionViewController {
    
    // Так делать наверно тоже нехорошо..
    var images: [ImageModel] = [ImageModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var fetchingMore = false
    var pageNumber: Int = 1
    
    let itemsPerRow: CGFloat = 2
    let itemsPerCol: CGFloat = 5
    
    let sectionInsets =  UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return images.count
        }
        else if section == 1 && fetchingMore {
            return 1
        }
        return 0
        
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let paddingHeight = sectionInsets.left * (itemsPerCol + 1)
        
        let availableWidth = collectionView.frame.width - paddingWidth
        let availableHeight = collectionView.frame.height - paddingHeight
        
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = availableHeight / itemsPerCol
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }
    
}


// P.S. Я пытался научиться в MVP, а еще больше потратил времени на RxAlmofire, но так и не получилось( если бы кто-нибудь показал наглядно, я бы сразу схватил. Если не сложно, подскажите пожалуйста
