//
//  MockStorage.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

class MockStorage {
    static let shared = MockStorage()
    let shipperBox = "shipperBox"
    let mailerBox = "standardMailerBox"
    lazy var data = [
        CardCellDisplayable(imageViewFileName: shipperBox, title: "ShipperBox1", subtitle: "12x12x8", details: "Is this my espresso machine?", itemImageName: "qrcode"),
        CardCellDisplayable(imageViewFileName: mailerBox, title: "MailerBox1", subtitle: "10x8x4", details: "Hey, you know how I'm, like, always trying to save the planet?", itemImageName: "qrcode"),
        CardCellDisplayable(imageViewFileName: shipperBox, title: "ShipperBox2", subtitle: "8x6x4", details: "Yes, Yes, without the oops! ", itemImageName: "qrcode")
    ]
    
    private init() {}
}
