//
//  ProductAsset.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct ProductAsset: Codable {
    var urlString: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url"
        case name = "label"
    }
    
}
