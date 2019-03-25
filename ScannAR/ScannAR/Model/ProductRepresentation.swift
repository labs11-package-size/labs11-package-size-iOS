//
//  ProductRepresentation.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct ProductRepresentation: Decodable {
    
    var fragile: Bool
    var height: Double
    var identifier: String
    var length: Double
    var manufacturerId: String
    var name: String
    var productDescription: String
    var userId: String
    var value: Double
    var weight: Double
    var width: Double
    
    enum CodingKeys: String, CodingKey {
        case fragile
        case height
        case identifier
        case length
        case manufacturerId
        case name
        case productDescription
        case userId
        case value
        case weight
        case width
    }
    
    
}

func ==(lhs: ProductRepresentation, rhs: Product) -> Bool {
    return rhs.identifier == lhs.identifier &&
        rhs.name == lhs.name &&
        rhs.manufacturerId == lhs.manufacturerId &&
        rhs.value == lhs.value
}

func ==(lhs: Product, rhs: ProductRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: ProductRepresentation, rhs: Product) -> Bool {
    return !(lhs == rhs)
}

func !=(lhs: Product, rhs: ProductRepresentation) -> Bool {
    return rhs != lhs
}

