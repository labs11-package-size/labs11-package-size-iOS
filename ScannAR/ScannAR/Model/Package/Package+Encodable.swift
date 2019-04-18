//
//  Package+Encodable.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import CoreData

extension Package: Encodable {
    
    enum CodingKeys: String, CodingKey {
        
        case identifier
        case uuid
        case lastUpdated
        case totalWeight
        case modelURL
        case dimensions
        case productNames
        case productUuids
    
    }
    
    // MARK: - Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(lastUpdated, forKey: .lastUpdated)
        try container.encode(totalWeight, forKey: .totalWeight)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(modelURL, forKey: .modelURL)
        try container.encode(dimensions, forKey: .dimensions)
        try container.encode(productNames, forKey: .productNames)
        try container.encode(productUuids, forKey: .productUuids)
    }
    
}
