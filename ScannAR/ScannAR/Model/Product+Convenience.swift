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
                     height: Double,
                     identifier: Int,
                     length: Double,
                     manufacturerId: String,
                     name: String,
                     productDescription: String,
                     userId: Int,
                     value: Double,
                     weight: Double,
                     width: Double,
                     uuid: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        self.init(context:context)
        self.fragile = Int16(fragile)
        self.height = height
        self.identifier = Int16(identifier)
        self.length = length
        self.manufacturerId = manufacturerId
        self.name = name
        self.productDescription = productDescription
        self.userId = Int16(userId)
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
        let manufacturerId = productRepresentation.manufacturerId
        let name = productRepresentation.name
        let productDescription = productRepresentation.productDescription
        let userId = productRepresentation.userId
        let value = productRepresentation.value
        let weight = productRepresentation.weight
        let uuid = productRepresentation.uuid
        
        var width: Double
        if productRepresentation.width != nil {
            width = productRepresentation.width!
        } else {
            width = 0.0
        }
        
        self.init(fragile: fragile, height: height, identifier: identifier, length: length, manufacturerId: manufacturerId, name: name, productDescription: productDescription, userId: userId, value: value, weight: weight, width: width, uuid: uuid, context: context)
    }
}
