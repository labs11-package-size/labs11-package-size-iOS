//
//  JSONWebToken.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/25/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct JSONWebToken: Codable {
    var token : String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
