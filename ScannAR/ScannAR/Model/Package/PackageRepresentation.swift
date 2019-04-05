//
//  PackageRepresentation.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//


import Foundation

struct PackageRepresentation: Codable {
    
    let identifier: Int
    let totalWeight: Double?
    let lastUpdated: String?
    let uuid: UUID
    let itemCount: Int
    let modelURL: String
    let boxId: Int
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case uuid
        case totalWeight
        case lastUpdated
        case itemCount
        case boxId
        case modelURL
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
