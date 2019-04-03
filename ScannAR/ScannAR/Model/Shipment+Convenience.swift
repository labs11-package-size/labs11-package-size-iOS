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
    convenience init(identifier: Int? = nil,
                     carrierName: String?,
                     productId: Int? = nil,
                     shippedDate: Date?,
                     shippingType: String?,
                     status: Int,
                     trackingNumber: String,
                     shippedTo: String?,
                     uuid: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
        
        if let identifier = identifier {
            self.identifier = Int16(identifier)
        }
        if let productId = productId {
            self.productId = Int16(productId)
        }
        
        
        self.carrierName = carrierName
        self.shippedDate = shippedDate
        self.shippingType = shippingType
        self.status = Int16(status)
        self.trackingNumber = trackingNumber
        self.shippedTo = shippedTo
        self.uuid = uuid
        
    }
    
    
    convenience init(shipmentRepresentation: ShipmentRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let identifier = shipmentRepresentation.identifier
        let carrierName = shipmentRepresentation.carrierName
        let productId = shipmentRepresentation.productId
    
        let shippingType = shipmentRepresentation.shippingType
        let status = shipmentRepresentation.status
        let trackingNumber = shipmentRepresentation.trackingNumber
        let shippedTo = shipmentRepresentation.shippedTo
        let uuid = shipmentRepresentation.uuid
        
        var shippedDate: Date?
        if let shipmentShippedDate = shipmentRepresentation.shippedDate {
            
            if shipmentShippedDate == "null"{
                shippedDate = nil
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
            
            if let date = dateFormatter.date(from: shipmentShippedDate) {
                shippedDate = date
            } else {
                shippedDate = nil
            }
        } else {
            shippedDate = nil
        }
        
        self.init(identifier: identifier, carrierName: carrierName, productId: productId, shippedDate: shippedDate, shippingType: shippingType, status: status, trackingNumber: trackingNumber, shippedTo: shippedTo, uuid: uuid, context: context)
    }
    
    
}
