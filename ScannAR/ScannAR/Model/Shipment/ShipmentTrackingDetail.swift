//
//  ShipmentTrackingDetail.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

public class ShipmentTrackingDetail: NSObject, Codable {
    var location: String
    var timestamp: String
    var details: String
    
//    public func encode(with coder: NSCoder) {
//        
//    }
//    public required convenience init(coder decoder: NSCoder) {
//        
//    }
    enum CodingKeys: String, CodingKey {
        case location
        case timestamp
        case details
    }
}
