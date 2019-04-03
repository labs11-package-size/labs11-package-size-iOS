//
//  Product+Convenience.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import CoreData

extension Product {
    
    convenience init(fragile: Int,
                     height: Double? = nil,
                     lastUpdated: Date? = Date(),
                     identifier: Int? = nil,
                     length: Double? = nil,
                     manufacturerId: String?,
                     name: String,
                     productDescription: String? = "",
                     userId: Int? = nil,
                     value: Double,
                     weight: Double,
                     width: Double,
                     uuid: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        self.init(context:context)
        
        
        if let identifier = identifier{
            self.identifier = Int16(identifier)
        }
        if let userId = userId {
            self.userId = Int16(userId)
        }
        if let manufacturerId = manufacturerId {
            self.manufacturerId = manufacturerId
        }
        
        if let height = height {
            self.height = height
        }
        if let length = length {
            self.length = length
        }
        
        self.lastUpdated = lastUpdated
        self.fragile = Int16(fragile)
        self.name = name
        self.productDescription = productDescription
        self.value = value
        self.weight = weight
        self.width = width
        self.uuid = uuid
    
    }
    
    convenience init(productRepresentation: ProductRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let identifier = productRepresentation.identifier
        let fragile = productRepresentation.fragile
        let height = productRepresentation.height
        let length = productRepresentation.length
        let name = productRepresentation.name
        let productDescription = productRepresentation.productDescription
        let userId = productRepresentation.userId
        let value = productRepresentation.value
        let weight = productRepresentation.weight
        let uuid = productRepresentation.uuid
        
        var manufacturerId: String?
        if productRepresentation.manufacturerId == "null"{
            manufacturerId = nil
        } else {
            manufacturerId = productRepresentation.manufacturerId
        }
        
        var lastUpdated: Date?
        if let productLastUpdated = productRepresentation.lastUpdated {
            
            if productLastUpdated == "null"{
                lastUpdated = nil
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
            
            if let date = dateFormatter.date(from: productLastUpdated) {
                lastUpdated = date
            } else {
                lastUpdated = nil
            }
        } else {
            lastUpdated = nil
        }
        
        
        var width: Double
        if productRepresentation.width != nil {
            width = productRepresentation.width!
        } else {
            width = 0.0
        }
        
        self.init(fragile: fragile, height: height, lastUpdated: lastUpdated, identifier: identifier, length: length, manufacturerId: manufacturerId, name: name, productDescription: productDescription, userId: userId, value: value, weight: weight, width: width, uuid: uuid, context: context)
    }
}
