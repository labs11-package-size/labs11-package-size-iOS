//
//  PackageConfiguration.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct PackageConfiguration: Codable {
    let size, id: String
    let size1: Double
    let size2, size3, weightLimit, currWeight: Double
    let itemCount: Int
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case size, id
        case size1 = "size_1"
        case size2 = "size_2"
        case size3 = "size_3"
        case weightLimit = "weight_limit"
        case currWeight = "curr_weight"
        case itemCount = "item_count"
        case items
    }
    
    struct Item: Codable {
        let uuid: String
        let id, origSize, spSize: String
        let size1, size2, size3, spSize1: Double
        let spSize2, spSize3: Double
        let xOriginInBin: Double
        let yOriginInBin: Double
        let zOriginInBin: Double
        let weight, constraints: Double
        
        enum CodingKeys: String, CodingKey {
            case id
            case uuid
            case origSize = "orig_size"
            case spSize = "sp_size"
            case size1 = "size_1"
            case size2 = "size_2"
            case size3 = "size_3"
            case spSize1 = "sp_size_1"
            case spSize2 = "sp_size_2"
            case spSize3 = "sp_size_3"
            case xOriginInBin = "x_origin_in_bin"
            case yOriginInBin = "y_origin_in_bin"
            case zOriginInBin = "z_origin_in_bin"
            case weight, constraints
        }
    }
    
}
