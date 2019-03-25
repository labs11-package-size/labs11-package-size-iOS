//
//  ProductsResult.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct ProductsResult: Decodable {
    var products : [ProductRepresentation]
    
    enum CodingKeys: CodingKey {
        case products
    }
    
}
