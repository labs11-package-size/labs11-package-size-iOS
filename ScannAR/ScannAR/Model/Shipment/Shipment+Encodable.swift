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
        case productNames
        case shippedDate
        case shippedTo
        case shippingType
        case status
        case trackingNumber
        case uuid
        case dateArrived
        case lastUpdated
        case totalWeight
        case totalValue
    }
    
    // MARK: - Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(carrierName, forKey: .carrierName)
        try container.encode(productNames, forKey: .productNames)
        try container.encode(shippedDate, forKey: .shippedDate)
        try container.encode(shippedTo, forKey: .shippedTo)
        try container.encode(shippingType, forKey: .shippingType)
        try container.encode(status, forKey: .status)
        try container.encode(trackingNumber, forKey: .trackingNumber)
        try container.encode(lastUpdated, forKey: .lastUpdated)
        try container.encode(totalValue, forKey: .totalValue)
        try container.encode(totalWeight, forKey: .totalWeight)
        try container.encode(dateArrived, forKey: .dateArrived)
        try container.encode(uuid, forKey: .uuid)
    }
    
}
