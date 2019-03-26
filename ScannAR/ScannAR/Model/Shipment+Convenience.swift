//
//  Shipment+Convenience.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import CoreData

extension Shipment {
    convenience init(identifier: String,
                     carrierName: String?,
                     productId: String,
                     shippedDate: Date,
                     shippingType: String?,
                     status: Int,
                     trackingNumber: String,
                     shippedTo: String?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        self.init(context:context)
        self.identifier = identifier
        self.carrierName = carrierName
        self.productId = productId
        self.shippedDate = shippedDate
        self.shippingType = shippingType
        self.status = Int16(status)
        self.trackingNumber = trackingNumber
        self.shippedTo = shippedTo
        
    }
    
    convenience init(shipmentRepresentation: ShipmentRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let identifier = shipmentRepresentation.identifier
        let carrierName = shipmentRepresentation.carrierName
        let productId = shipmentRepresentation.productId
        let shippedDate = shipmentRepresentation.shippedDate
        let shippingType = shipmentRepresentation.shippedType
        let status = shipmentRepresentation.status
        let trackingNumber = shipmentRepresentation.trackingNumber
        let shippedTo = shipmentRepresentation.shippedTo
        
        self.init(identifier: identifier, carrierName: carrierName, productId: productId, shippedDate: shippedDate, shippingType: shippingType, status: status, trackingNumber: trackingNumber, shippedTo: shippedTo, context: context)
    }
    
    
}
