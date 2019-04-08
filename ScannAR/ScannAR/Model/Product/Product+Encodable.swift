//
//  Product+Encodable.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

extension Product : Encodable {
    
    enum CodingKeys: String, CodingKey {
        case fragile
        case height
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
    
    // MARK: - Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fragile, forKey: .fragile)
        try container.encode(height, forKey: .height)
        try container.encode(length, forKey: .length)
        try container.encode(manufacturerId, forKey: .manufacturerId)
        try container.encode(name, forKey: .name)
        try container.encode(productDescription, forKey: .productDescription)
        try container.encode(value, forKey: .value)
        try container.encode(weight, forKey: .weight)
        try container.encode(width, forKey: .width)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(thumbnail, forKey: .thumbnail)
    }
    
}
