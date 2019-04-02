//
//  MessageLabel.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class MessageLabel: UILabel {
   
    
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += 20
        contentSize.height += 20
        return contentSize
    }
    
    func display(_ message: Message) {
        DispatchQueue.main.async {
            self.attributedText = message.text
            self.isHidden = false
        }
    }
    
    func clear() {
        DispatchQueue.main.async {
            self.text = ""
            self.isHidden = true
        }
    }
}
