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
    let identifier: Int
    let productId: Int
    let shippedDate: Date
    let shippedTo: String
    let shippingType: String
    let status: Int
    let trackingNumber: String
    let uuid: UUID
    
    enum CodingKeys: String, CodingKey {
        case carrierName
        case identifier
        case productId
        case shippedDate = "dateShipped"
        case shippedTo
        case shippingType
        case status
        case trackingNumber
        case uuid
    }
    
}

func ==(lhs: ShipmentRepresentation, rhs: Shipment) -> Bool {
    return rhs.productId == lhs.productId &&
        rhs.shippedDate == lhs.shippedDate &&
        rhs.status == lhs.status &&
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
