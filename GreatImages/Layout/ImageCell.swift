//
//  NewCell.swift
//  GreatImages
//
//  Created by Роман on 23.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit

// Я использую одну и ту же ячейку для разных UICollectionViewControllers
class ImageCell: UICollectionViewCell {
    static let id = "imageCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }
}

