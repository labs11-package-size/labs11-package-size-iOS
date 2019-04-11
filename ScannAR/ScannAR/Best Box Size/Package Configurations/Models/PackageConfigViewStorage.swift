//
//  PackageConfigViewStorage.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class PackageConfigViewStorage {
    static let shared = PackageConfigViewStorage()
//    let shipperBox = "shipperBox"
//    let mailerBox = "standardMailerBox"
    var boxType: BoxType = .mailer
    var boxTypeImageViewFileName: String = ""
    lazy var data = [PackageConfiguration(size: "10 x 8 x 4", id: "22", size1: 10.0, size2: 8.0, size3: 4.0, weightLimit: 100.0, currWeight: 17.0, itemCount: 1, items: [ScannAR.PackageConfiguration.Item(uuid: "3f6f5d38-5bd7-11e9-ae06-5bb21db284ac", id: "111", origSize: "10 x 7 x 3", spSize: "10 x 7 x 3", size1: 10.0, size2: 7.0, size3: 3.0, spSize1: 10.0, spSize2: 7.0, spSize3: 3.0, xOriginInBin: 0.0, yOriginInBin: -0.5, zOriginInBin: 0.5, weight: 17.0, constraints: 0.0)])
//        CardCellDisplayable(boxTypeImageViewFileName: shipperBox, title: "ShipperBox1", subtitle: "12x12x8", details: "Is this my espresso machine?", itemImageName: "1"),
//        CardCellDisplayable(boxTypeImageViewFileName: mailerBox, title: "MailerBox1", subtitle: "10x8x4", details: "Hey, you know how I'm, like, always trying to save the planet?", itemImageName: "2"),
//        CardCellDisplayable(boxTypeImageViewFileName: shipperBox, title: "ShipperBox2", subtitle: "8x6x4", details: "Yes, Yes, without the oops! ", itemImageName: "3")
    ]
    
    
}

