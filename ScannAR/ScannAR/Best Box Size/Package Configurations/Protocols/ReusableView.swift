//
//  ReusableView.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

/// All objects adopting this protocol will use the same identifier as their class's name.
protocol ReusableView: class {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReusableView {}
extension UIView: ReusableView {}
