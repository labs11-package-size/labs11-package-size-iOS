//
//  ShippingStatus.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

enum ShippingStatus: Int {
    
    case Unknown = 0
    case Shipping = 1
    case EnRoute = 2
    case OutForDelivery = 3
    case Delivered = 4
    case Delayed = 5
}
