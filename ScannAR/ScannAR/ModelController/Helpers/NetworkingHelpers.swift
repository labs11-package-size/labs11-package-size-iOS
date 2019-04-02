//
//  NetworkingHelpers.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
struct Account{
    var displayName: String?
    var email: String?
    var photoURL: String?
}
class NetworkingHelpers{
    
    static func dictionaryFromProduct(product:Product) -> [String: String]{
        var dict: [String: String] = [:]
        
        dict["name"] = product.name
        dict["productDescription"] = product.productDescription
        dict["weight"] = "\(product.weight)"
        dict["value"] = "\(product.value)"
        dict["manufacturerId"] = product.manufacturerId
        dict["fragile"] = "\(product.fragile)"
        dict["userId"] = "\(product.userId)"
        
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
