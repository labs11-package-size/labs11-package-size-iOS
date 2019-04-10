//
//  MockStorage.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class MockStorage {
    static let shared = MockStorage()
    let shipperBox = "shipperBox"
    let mailerBox = "standardMailerBox"
    lazy var data = [
        CardCellDisplayable(boxTypeImageViewFileName: shipperBox, title: "ShipperBox1", subtitle: "12x12x8", details: "Is this my espresso machine?", itemImageName: "1"),
        CardCellDisplayable(boxTypeImageViewFileName: mailerBox, title: "MailerBox1", subtitle: "10x8x4", details: "Hey, you know how I'm, like, always trying to save the planet?", itemImageName: "2"),
        CardCellDisplayable(boxTypeImageViewFileName: shipperBox, title: "ShipperBox2", subtitle: "8x6x4", details: "Yes, Yes, without the oops! ", itemImageName: "3")
    ]
    
    
    private init() {}
}

