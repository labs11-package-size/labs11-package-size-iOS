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
    convenience init(fragile: Bool,
                     height: Double,
                     identifier: String,
                     length: Double,
                     manufacturerId: String,
                     name: String,
                     productDescription: String,
                     userId: String,
                     value: Double,
                     weight: Double,
                     width: Double,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
        self.fragile = fragile
        self.height = height
        self.identifier = identifier
        self.length = length
        self.manufacturerId = manufacturerId
        self.name = name
        self.productDescription = productDescription
        self.userId = userId
        self.value = value
        self.weight = weight
        self.width = width
    
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
        let width = productRepresentation.width
        
        self.init(identifier: identifier, fragile: fragile, height: height, length: length, manufacturerId: manufacturerId, name: name, productDescription: productDescription, userId: userId, value: value, weight: width, context: context)
    }
}
