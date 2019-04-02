//
//  Message.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class Message {
    // The title and body of this message
    private(set) var text: NSMutableAttributedString
    
    init(_ body: String, title: String? = nil) {
        if let title = title {
            // Make the title bold
            text = NSMutableAttributedString(string: "\(title)\n\(body)")
            let titleRange = NSRange(location: 0, length: title.count)
            text.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: titleRange)
            text.addAttribute(.foregroundColor, value: UIColor.appGreen, range: titleRange)
            
        } else {
            text = NSMutableAttributedString(string: body)
            let bodyRange = NSRange(location: 0, length: body.count)
            text.addAttribute(.foregroundColor, value: UIColor.appGreen, range: bodyRange)
        }
    }
    
    func printToConsole() {
        print(text.string)
    }
    
}
