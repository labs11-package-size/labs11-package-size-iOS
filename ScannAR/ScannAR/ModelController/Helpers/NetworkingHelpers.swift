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
        
        return dict
    }
    
    static func dictionaryFromAccount(account:Account) -> [String: String]{
        var dict: [String: String] = [:]
        
        dict["displayName"] = account.displayName
        dict["email"] = account.email
        dict["photoURL"] = account.photoURL
        
        return dict
    }
}
