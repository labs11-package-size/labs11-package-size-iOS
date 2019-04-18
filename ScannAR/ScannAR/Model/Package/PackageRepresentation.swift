//
//  PackageRepresentation.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//


import Foundation

struct PackageRepresentation: Codable {
    
    let identifier: Int?
    let dimensions: String
    let totalWeight: Double?
    let lastUpdated: String?
    let productNames: [String]?
    let productUuids: [String]?
    let uuid: UUID
    let modelURL: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case dimensions
        case uuid
        case totalWeight
        case lastUpdated
        case modelURL
        case productNames
        case productUuids
    }
    
}

func ==(lhs: PackageRepresentation, rhs: Package) -> Bool {
    return rhs.uuid == lhs.uuid
}

func ==(lhs: Package, rhs: PackageRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: PackageRepresentation, rhs: Package) -> Bool {
    return !(lhs == rhs)
}

func !=(lhs: Package, rhs: PackageRepresentation) -> Bool {
    return rhs != lhs
}
