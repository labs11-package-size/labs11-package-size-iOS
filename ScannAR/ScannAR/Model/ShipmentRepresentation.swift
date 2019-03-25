//
//  ShipmentRepresentation.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct ShipmentRepresentation: Decodable {
    
    var carrierName: String
    var identifier: String
    var productId: String
    var shippedDate: Date
    var shippedTo: String
    var shippedType: String
    var status: Int
    var trackingNumber: String
    
    enum CodingKeys: String, CodingKey {
        case carrierName
        case identifier
        case productId
        case shippedDate
        case shippedTo
        case shippedType
        case status
        case trackingNumber
    }
    
    
}

func ==(lhs: ShipmentRepresentation, rhs: Shipment) -> Bool {
    return rhs.identifier == lhs.identifier &&
        rhs.productId == lhs.productId &&
        rhs.shippedDate == lhs.shippedDate &&
        rhs.status == lhs.status &&
        rhs.trackingNumber == lhs.trackingNumber
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
