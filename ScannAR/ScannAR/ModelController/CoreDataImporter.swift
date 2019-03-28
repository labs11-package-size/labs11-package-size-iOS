//
//  CoreDataImporter.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import CoreData

class CoreDataImporter {
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func syncProducts(productRepresentations: [ProductRepresentation], completion: @escaping (Error?) -> Void = { _ in }) {
        
        self.context.perform {
            
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest() // create an Entry NSFetchRequest
            var result: [Product]? = nil // create an entry array named 'result' that will store the entries you find in the Persistent Store
            
            do { // in the current (background) context, perform the fetch request from the persistent store
                result = try self.context.fetch(fetchRequest) // assign the (error-throwing) fetch request, done on the background context, to result
            } catch {
                NSLog("Error fetching list of Products: \(error)") // if the fetch request throws an error, NSLog it
            }
            
            // we now need to check to see that we have results back
            // if we do, let's create a dictionary to put those results in
            
            if let alreadyInCoreDataProducts = result, alreadyInCoreDataProducts.count > 0 {
                var coreDataDictionary: [String: Product] = [:] // if there is already a list of arrays in core data, make a dictionary
                
                for existingProduct in alreadyInCoreDataProducts {
                    guard let productUUID = existingProduct.uuid?.uuidString else { return }
                    coreDataDictionary[productUUID] = existingProduct
                }
                
                for productRepresentation in productRepresentations {
                    let productUUID = productRepresentation.uuid.uuidString
                    
                    
                    if let product = coreDataDictionary[productUUID], product != productRepresentation {
                        self.updateProduct(product: product, with: productRepresentation)
                    } else if coreDataDictionary[productUUID] == nil {
                        _ = Product(productRepresentation: productRepresentation, context: self.context)
                    }
                    
                }
                
            } else {
                // the fetch request returned no results, meaning there was nothing in core data,
                // meaning all we have to do is just create new entries from each entry representation
                
                for productRepresentation in productRepresentations {
                    _ = Product(productRepresentation: productRepresentation, context: self.context)
                }
                
            }
            
            do {
                try self.context.save()
            } catch let saveError {
                print("Error saving context: \(saveError)")
            }
            
            completion(nil)
        }
    }
    
    func syncShipments(shipmentRepresentations: [ShipmentRepresentation], completion: @escaping (Error?) -> Void = { _ in }) {
        
        self.context.perform {
            
            let fetchRequest: NSFetchRequest<Shipment> = Shipment.fetchRequest() // create an Entry NSFetchRequest
            var result: [Shipment]? = nil // create an entry array named 'result' that will store the entries you find in the Persistent Store
            
            do { // in the current (background) context, perform the fetch request from the persistent store
                result = try self.context.fetch(fetchRequest) // assign the (error-throwing) fetch request, done on the background context, to result
            } catch {
                NSLog("Error fetching list of Shipments: \(error)") // if the fetch request throws an error, NSLog it
            }
            
            // we now need to check to see that we have results back
            // if we do, let's create a dictionary to put those results in
            
            if let alreadyInCoreDataShipments = result {
                var coreDataDictionary: [String: Shipment] = [:] // if there is already a list of arrays in core data, make a dictionary
                
                for existingShipment in alreadyInCoreDataShipments {
                    guard let shipmentUUID = existingShipment.uuid?.uuidString else { return }
                    coreDataDictionary[shipmentUUID] = existingShipment
                }
                
                for shipmentRepresentation in shipmentRepresentations {
                    let shipmentUUID = shipmentRepresentation.uuid.uuidString
                    
                    
                    if let shipment = coreDataDictionary[shipmentUUID], shipment != shipmentRepresentation {
                        self.updateShipment(shipment: shipment, with: shipmentRepresentation)
                    } else if coreDataDictionary[shipmentUUID] == nil {
                        _ = Shipment(shipmentRepresentation: shipmentRepresentation, context: self.context)
                    }
                    
                }
                
            } else {
                // the fetch request returned no results, meaning there was nothing in core data,
                // meaning all we have to do is just create new entries from each entry representation
                
                for shipmentRepresentation in shipmentRepresentations {
                    _ = Shipment(shipmentRepresentation: shipmentRepresentation, context: self.context)
                }
                
            }
            
            do {
                try self.context.save()
            } catch let saveError {
                print("Error saving context: \(saveError)")
            }
            
            completion(nil)
        }
    }
    
    
    
    private func updateProduct(product: Product, with productRepresentation: ProductRepresentation) {
        product.identifier = Int16(productRepresentation.identifier)
        product.fragile = Int16(productRepresentation.fragile)
        product.height = productRepresentation.height ?? 0
        product.length = productRepresentation.length ?? 0
        product.manufacturerId = productRepresentation.manufacturerId
        product.name = productRepresentation.name
        product.productDescription = productRepresentation.productDescription
        product.userId = Int16(productRepresentation.userId)
        product.value = productRepresentation.value
        product.weight = productRepresentation.weight
        product.uuid = productRepresentation.uuid
        product.width = productRepresentation.width ?? 0
    }
    
    private func updateShipment(shipment: Shipment, with shipmentRepresentation: ShipmentRepresentation) {
        
        shipment.identifier = Int16(shipmentRepresentation.identifier)
        shipment.carrierName = shipmentRepresentation.carrierName
        shipment.productId = Int16(shipmentRepresentation.productId)
        shipment.shippedDate = shipmentRepresentation.shippedDate
        shipment.shippingType = shipmentRepresentation.shippingType
        shipment.status = Int16(shipmentRepresentation.status)
        shipment.trackingNumber = shipmentRepresentation.trackingNumber
        shipment.shippedTo = shipmentRepresentation.shippedTo
        shipment.uuid = shipmentRepresentation.uuid
    }
    
    let context: NSManagedObjectContext
}
