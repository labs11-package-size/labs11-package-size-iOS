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
    
    static let boxVarieties: [String: BoxType] = [
        "6 x 6 x 2": .mailer,
        "7 x 5.5 x 1.25": .mailer,
        "8 x 5 x 2": .mailer,
        "9 x 6 x 3": .mailer,
        "9 x 8 x 2": .mailer,
        "10 x 8 x 4": .mailer,
        "12.5 x 10 x 4": .mailer,
        "6 x 6 x 6": .shipper,
        "8 x 6 x 4": .shipper,
        "8 x 8 x 8": .shipper,
        "10 x 8 x 6": .shipper,
        "10 x 10 x 10": .shipper,
        "12 x 6 x 6": .shipper,
        "12 x 12 x 8": .shipper,
        "12 x 12 x 12": .shipper,
        "16 x 12 x 8": .shipper ]
}
