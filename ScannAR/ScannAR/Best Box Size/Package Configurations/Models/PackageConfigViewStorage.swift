//
//  PackageConfigViewStorage.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class PackageConfigViewStorage {
    static let shared = PackageConfigViewStorage()
    var boxType: BoxType!
    var boxTypeImageViewFileName: String = ""
    var data: [PackageConfiguration] = []
    
    
}

