//
//  CoreDataStack.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    /** singleton for accessesing CoreDataStack class methods
     */
    static let shared = CoreDataStack()
    private init() {}
    
    lazy var container: NSPersistentContainer = { () -> NSPersistentContainer in
        let container = NSPersistentContainer(name: "ScannAR")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        // If there was an error, the error var will be non nil
        if let error = error {
            throw error
        }
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.mainContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                self.mainContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func resetCoreData() {
        self.deleteAllData("Product")
        self.deleteAllData("Package")
        self.deleteAllData("Shipment")
    }
}


