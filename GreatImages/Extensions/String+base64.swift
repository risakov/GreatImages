//
//  String+toLengthOf.swift
//  GreatImages
//
//  Created by Роман on 28.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
}
