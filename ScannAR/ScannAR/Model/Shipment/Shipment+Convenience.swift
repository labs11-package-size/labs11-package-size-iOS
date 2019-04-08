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
    convenience init(carrierName: String?,
                     productNames: [String]?,
                     shippedDate: Date?,
                     dateArrived: Date?,
                     lastUpdated: Date?,
                     shippingType: String?,
                     totalWeight: Double = 0,
                     totalValue: Double = 0,
                     status: Int,
                     trackingNumber: String,
                     shippedTo: String?,
                     uuid: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
      
    
        self.productNames = productNames
        self.carrierName = carrierName
        self.shippedDate = shippedDate
        self.dateArrived = dateArrived
        self.lastUpdated = lastUpdated
        self.shippingType = shippingType
        self.status = Int16(status)
        self.trackingNumber = trackingNumber
        self.shippedTo = shippedTo
        self.uuid = uuid
        self.totalWeight = totalWeight
        self.totalValue = totalValue
        
    }
    
    
    convenience init(shipmentRepresentation: ShipmentRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let carrierName = shipmentRepresentation.carrierName
        
        let totalValue = shipmentRepresentation.totalValue ?? 0.0
        let totalWeight = shipmentRepresentation.totalWeight ?? 0.0
    
        let shippingType = shipmentRepresentation.shippingType
        let status = shipmentRepresentation.status
        let trackingNumber = shipmentRepresentation.trackingNumber
        let shippedTo = shipmentRepresentation.shippedTo
        let uuid = shipmentRepresentation.uuid
        let productNames = shipmentRepresentation.productNames
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
        
        var shippedDate: Date?
        if let shipmentShippedDate = shipmentRepresentation.shippedDate {
            
            if shipmentShippedDate == "null"{
                shippedDate = nil
            }
            
            if let date = dateFormatter.date(from: shipmentShippedDate) {
                shippedDate = date
            } else {
                shippedDate = nil
            }
        } else {
            shippedDate = nil
        }
        
        var dateArrived: Date?
        if let shipmentDateArrived = shipmentRepresentation.dateArrived {
            
            if shipmentDateArrived == "null"{
                dateArrived = nil
            }
            
            if let date = dateFormatter.date(from: shipmentDateArrived) {
                dateArrived = date
            } else {
                dateArrived = nil
            }
        } else {
            dateArrived = nil
        }
        
        var lastUpdated: Date?
        if let shipmentLastUpdated = shipmentRepresentation.lastUpdated {
            
            if shipmentLastUpdated == "null"{
                lastUpdated = nil
            }
            
            if let date = dateFormatter.date(from: shipmentLastUpdated) {
                lastUpdated = date
            } else {
                lastUpdated = nil
            }
        } else {
            lastUpdated = nil
        }
        
        self.init(carrierName: carrierName, productNames: productNames, shippedDate: shippedDate, dateArrived: dateArrived, lastUpdated: lastUpdated, shippingType: shippingType, totalWeight: totalWeight, totalValue: totalValue, status: status, trackingNumber: trackingNumber, shippedTo: shippedTo, uuid: uuid, context: context)
    }
    
    
}
