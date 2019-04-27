//
//  Alert.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

@objc public class Alert: NSObject {
    var image: UIImage
    var title: String
    var text: String
    
    @objc public init(image: UIImage, title: String, text: String) {
        self.image = image
        self.title = title
        self.text = text
    }
}
