//
//  ShipmentStatus.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/11/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct ShipmentStatus {
    static let dict: [Int:String] = [0: "Unknown",
                                     1: "Shipping",
                                     2: "En-Route",
                                     3: "Out-For-Delivery",
                                     4: "Delivered",
                                     5: "Delayed"]
}

