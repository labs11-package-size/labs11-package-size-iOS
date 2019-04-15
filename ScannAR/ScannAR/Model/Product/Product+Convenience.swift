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
                     length: Double? = nil,
                     manufacturerId: String?,
                     name: String,
                     productDescription: String? = "",
                     value: Double,
                     weight: Double,
                     width: Double,
                     uuid: UUID? = UUID(),
                     thumbnail: URL?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        self.init(context:context)
        
        if let manufacturerId = manufacturerId {
            self.manufacturerId = manufacturerId
        }
        
        if let height = height {
            self.height = height
        }
        if let length = length {
            self.length = length
        }
        
        if let thumbnail = thumbnail {
            self.thumbnail = thumbnail
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
        
        let fragile = productRepresentation.fragile
        let height = productRepresentation.height
        let length = productRepresentation.length
        let name = productRepresentation.name
        let productDescription = productRepresentation.productDescription
        let value = productRepresentation.value
        let weight = productRepresentation.weight
        let uuid = productRepresentation.uuid
        
        var thumbnail: URL?
        if let productThumbnail = productRepresentation.thumbnail {
            
            if let productThumbnailSub = URL(string: productThumbnail) {
                thumbnail = productThumbnailSub
            }
        }
        
        
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
        
        self.init(fragile: fragile, height: height, lastUpdated: lastUpdated, length: length, manufacturerId: manufacturerId, name: name, productDescription: productDescription, value: value, weight: weight, width: width, uuid: uuid, thumbnail: thumbnail, context: context)
    }
}
