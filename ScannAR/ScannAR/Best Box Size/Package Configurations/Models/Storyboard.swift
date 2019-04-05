//
//  Storyboard.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    case main = "BestBoxSize"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(_ viewControllerClass: T.Type) -> T {
        return instance.instantiateViewController(withIdentifier: viewControllerClass.reuseIdentifier) as! T
    }
}
