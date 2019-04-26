//
//  AlertChildPageViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

@objc public class AlertChildPageViewController: UIViewController {
    
    var pageIndex: Int!
    
    @objc @IBOutlet public private(set) weak var image: UIImageView!
    @objc @IBOutlet public private(set) weak var labelMainTitle: UILabel!
    @objc @IBOutlet public private(set) weak var labelDescription: UITextView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
