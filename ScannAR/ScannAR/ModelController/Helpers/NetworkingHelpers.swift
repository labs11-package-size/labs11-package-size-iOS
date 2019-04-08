//
//  NetworkingHelpers.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

class NetworkingHelpers{
    
    static func dictionaryFromProduct(product:Product) -> [String: String]{
        var dict: [String: String] = [:]
        
        dict["name"] = product.name
        dict["productDescription"] = product.productDescription
        dict["weight"] = "\(product.weight)"
        dict["length"] = "\(product.length)"
        dict["width"] = "\(product.width)"
        dict["height"] = "\(product.height)"
        dict["value"] = "\(product.value)"
        dict["manufacturerId"] = product.manufacturerId
        dict["fragile"] = "\(product.fragile)"
        
        guard let uuid = product.uuid else { return dict }
        
        dict["uuid"] = "\(uuid)"
        
        return dict
    }
    
    static func dictionaryFromProductForUpdate(product:Product) -> [String: String]{
        var dict: [String: String] = [:]
        
        dict["name"] = product.name
        dict["productDescription"] = product.productDescription
        dict["weight"] = "\(product.weight)"
        dict["value"] = "\(product.value)"
        dict["manufacturerId"] = product.manufacturerId
        dict["fragile"] = "\(product.fragile)"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:MM:SS"
        dict["lastUpdated"] = df.string(from: Date())
        
        return dict
    }
    
    static func dictionaryFromAccount(account:Account) -> [String: String]{
        var dict: [String: String] = [:]
        
        dict["displayName"] = account.displayName
        dict["email"] = account.email
        dict["photoURL"] = account.photoURL
        
        return dict
    }
    
    static func dictionaryFromProductAsset(productAsset:ProductAsset) -> [String: String]{
        var dict: [String: String] = [:]
        
        dict["label"] = productAsset.name
        dict["url"] = productAsset.urlString
        
        return dict
    }
    
    static func dictionaryFromProductArrayAndBoxType(productArray: [Product], boxType: BoxType? = nil) -> [String: [String]] {
        var dict: [String: [String]] = [:]
        var array: [String] = []
        
        for product in productArray {
            guard let uuid = product.uuid else { continue }
            array.append(uuid.uuidString)
        }
        
        dict["products"] = array
        // dict["boxType"] = "shipper"
        
        return dict
    }
    
    static func dictionaryFromShipment(shipment:Shipment) -> [String: String]{
        var dict: [String: String] = [:]
        
        dict["trackingNumber"] = shipment.trackingNumber
        
        return dict
    }
    
}
