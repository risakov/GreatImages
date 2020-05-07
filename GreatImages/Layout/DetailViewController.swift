//
//  DetailViewController.swift
//  GreatImages
//
//  Created by Роман on 23.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameOfNewImage: UILabel!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var descriptionOfNewImage: UITextView!
    var image: UIImage?
    var imageName: String?
    var imageDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = " "
        
        newImageView.image = image
        nameOfNewImage.text = "\(imageName!)"
        descriptionOfNewImage.text = "\(imageDescription!)"
    }
    
}
