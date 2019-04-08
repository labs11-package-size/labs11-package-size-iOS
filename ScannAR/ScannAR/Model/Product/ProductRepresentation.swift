//
//  ProductRepresentation.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct ProductRepresentation: Codable {
    
    var fragile: Int
    var height: Double?
    var lastUpdated: String?
    var length: Double?
    var manufacturerId: String?
    var name: String
    var productDescription: String
    var value: Double
    var weight: Double
    var width: Double?
    var uuid: UUID
    var thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case fragile
        case height
        case lastUpdated
        case length
        case manufacturerId
        case name
        case productDescription
        case value
        case weight
        case width
        case uuid
        case thumbnail
    }
    
    
}

func ==(lhs: ProductRepresentation, rhs: Product) -> Bool {
    return rhs.name == lhs.name &&
        rhs.manufacturerId == lhs.manufacturerId &&
        rhs.value == lhs.value &&
        rhs.uuid == lhs.uuid
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

