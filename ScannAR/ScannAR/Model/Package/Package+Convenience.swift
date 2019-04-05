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
                     itemCount: Int,
                     modelURL: String?,
                     boxId: Int,
                     uuid: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
        
        if let identifier = identifier {
            self.identifier = Int16(identifier)
        }
        if let modelURL = modelURL {
            self.modelURL = modelURL
        }
        
        
        self.boxId = Int16(boxId)
        self.itemCount = Int16(itemCount)
        self.lastUpdated = lastUpdated
        self.uuid = uuid
        self.totalWeight = totalWeight

        
    }
    
    
    convenience init(packageRepresentation: PackageRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let identifier = packageRepresentation.identifier
        let totalWeight = packageRepresentation.totalWeight ?? 0.0
        let itemCount = packageRepresentation.itemCount
        let modelURL = packageRepresentation.modelURL
        let boxId = packageRepresentation.boxId
        
        let uuid = packageRepresentation.uuid
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
        
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
        
        self.init(identifier: identifier, lastUpdated: lastUpdated, totalWeight: totalWeight, itemCount: itemCount, modelURL: modelURL, boxId: boxId, uuid: uuid, context: context)
    }
    
    
}
