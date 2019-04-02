//
//  APICallType.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

enum APICallType: String, Codable {
    
    // login & Auth
    case POSTWebToken
    case POSTRegisterNewUser
    case GETValidateToken
    
    // account info
    case GETAccountInfo
    case PUTEditAccountInfo
    
    // products
    case GETProducts
    case POSTNewProduct
    case DELETEProduct
    case PUTEditProduct
    case GETProductsAssets
    case POSTProductAsset
    
    // shipments
    case GETShipments
    case POSTNewShipment
    case DELETEShipment
    case PUTEditShipment
}
