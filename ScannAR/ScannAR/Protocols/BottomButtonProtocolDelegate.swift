//
//  BottomButtonProtocolDelegate.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/19/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

@objc protocol BottomButtonDelegate: class {
    @objc optional func packThisProduct()
    @objc optional func packMultipleProducts()
    @objc optional func useRecommendedBoxTapped()
    @objc optional func useAnotherBoxTapped()
    @objc optional func shipItTapped()
    @objc optional func trackingNumberEntered()
    @objc optional func trackItTapped()
}
