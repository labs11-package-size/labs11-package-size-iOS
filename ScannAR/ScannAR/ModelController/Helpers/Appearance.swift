//
//  Appearance.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/7/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

struct Appearance {
    static func setupNavAppearance() {
        UINavigationBar.appearance().tintColor = UIColor(named: "appARKADarkBlue")
        UINavigationBar.appearance().barTintColor = UIColor(named: "appARKATeal")
        UINavigationBar.appearance().titleTextAttributes = [ .foregroundColor: UIColor(named: "appARKATeal") ?? .white]
        UINavigationBar.appearance().isTranslucent = false
    }
}
