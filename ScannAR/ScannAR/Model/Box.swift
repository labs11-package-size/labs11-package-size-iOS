//
//  Box.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct Box: Codable {
    var dimensions: String
    var maxWeight: String
    var custom: Bool
    var uuid: UUID
    var lastUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case dimensions
        case maxWeight
        case custom
        case uuid
        case lastUpdated
    }
}
