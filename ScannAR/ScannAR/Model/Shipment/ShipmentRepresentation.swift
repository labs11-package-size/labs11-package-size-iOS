//
//  ShipmentRepresentation.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct ShipmentRepresentation: Codable {
    
    let carrierName: String
    let productNames: [String]?
    let dateArrived: String?
    let totalWeight: Double?
    let totalValue: Double?
    let lastUpdated: String?
    let shippedDate: String?
    let shippedTo: String
    let shippingType: String
    let status: Int
    let trackingNumber: String
    let uuid: UUID
    
    enum CodingKeys: String, CodingKey {
        case carrierName
        case productNames
        case shippedDate = "dateShipped"
        case shippedTo
        case shippingType
        case status
        case trackingNumber
        case uuid
        case totalWeight
        case totalValue
        case dateArrived
        case lastUpdated
    }
    
}

func ==(lhs: ShipmentRepresentation, rhs: Shipment) -> Bool {
    return rhs.status == lhs.status &&
        rhs.trackingNumber == lhs.trackingNumber &&
        rhs.uuid == lhs.uuid
}

func ==(lhs: Shipment, rhs: ShipmentRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: ShipmentRepresentation, rhs: Shipment) -> Bool {
    return !(lhs == rhs)
}

func !=(lhs: Shipment, rhs: ShipmentRepresentation) -> Bool {
    return rhs != lhs
}
