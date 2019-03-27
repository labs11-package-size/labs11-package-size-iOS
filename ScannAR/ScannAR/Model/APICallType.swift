//
//  APICallType.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

enum APICallType: String, Codable {
    case JobsRequestedByUser
    case JobsAvailableForUser
    case JobFromSingleUUID
}
