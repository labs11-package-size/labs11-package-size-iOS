//
//  Shipment+Encodable.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

extension Shipment: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case carrierName
        case identifier
        case productId
        case shippedDate
        case shippedTo
        case shippingType
        case status
        case trackingNumber
    }
    
    // MARK: - Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(carrierName, forKey: .carrierName)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(productId, forKey: .productId)
        try container.encode(shippedDate, forKey: .shippedDate)
        try container.encode(shippedTo, forKey: .shippedTo)
        try container.encode(shippingType, forKey: .shippingType)
        try container.encode(status, forKey: .status)
        try container.encode(trackingNumber, forKey: .trackingNumber)
    }
    
}
