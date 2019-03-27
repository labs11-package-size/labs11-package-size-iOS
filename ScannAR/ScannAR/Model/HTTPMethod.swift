//
//  HTTPMethod.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

enum HTTPMethod: String, Codable {
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
