//
//  Package+Convenience.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import CoreData

extension Package {
    convenience init(identifier: Int? = nil,
                     lastUpdated: Date?,
                     totalWeight: Double = 0,
                     productNames: [String]?,
                     productUuids: [String]?,
                     modelURL: String?,
                     dimensions: String,
                     uuid: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
        
        if let identifier = identifier {
            self.identifier = Int16(identifier)
        }
        if let modelURL = modelURL {
            self.modelURL = modelURL
        }
        
        if let productNames = productNames {
            self.productNames = productNames
        }
        
        if let productUuids = productUuids {
            self.productUuids = productUuids
        }
        
        self.dimensions = dimensions
        self.lastUpdated = lastUpdated
        self.uuid = uuid
        self.totalWeight = totalWeight

    }
    
    
    convenience init(packageRepresentation: PackageRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let dimensions = packageRepresentation.dimensions
        let identifier = packageRepresentation.identifier
        let totalWeight = packageRepresentation.totalWeight ?? 0.0
        let productNames = packageRepresentation.productNames
        let productUuids = packageRepresentation.productUuids
        let uuid = packageRepresentation.uuid
        
        var modelURL: String?
        if packageRepresentation.modelURL == "null"{
            modelURL = nil
        } else {
            modelURL = packageRepresentation.modelURL
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var lastUpdated: Date?
        if let packageLastUpdated = packageRepresentation.lastUpdated {
            
            if packageLastUpdated == "null"{
                lastUpdated = nil
            }
            
            if let date = dateFormatter.date(from: packageLastUpdated) {
                lastUpdated = date
            } else {
                lastUpdated = nil
            }
        } else {
            lastUpdated = nil
        }
        
        self.init(identifier: identifier, lastUpdated: lastUpdated, totalWeight: totalWeight, productNames: productNames, productUuids: productUuids, modelURL: modelURL, dimensions: dimensions, uuid: uuid, context: context)
    }
    
    
}
