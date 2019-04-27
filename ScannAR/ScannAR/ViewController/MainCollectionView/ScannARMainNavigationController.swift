//
//  ScannARMainNavigationController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ScannARMainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
}

extension ScannARMainNavigationController {
    
    // Change the name of the storyboard if this is not "Main"
    // identifier is the Storyboard ID that you put juste before
    class func instantiate() -> ScannARMainNavigationController {
        let storyboard = UIStoryboard(name: "ScannARMainViewController", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "ScannARMainNavigationControllerSB") as! ScannARMainNavigationController
        
        return navController
    }
    
}
