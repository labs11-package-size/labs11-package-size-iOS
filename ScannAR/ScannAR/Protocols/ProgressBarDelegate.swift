//
//  ProgressBarDelegate.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/19/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

protocol ProgressBarDelegate: class {
    func packThisBoxTapped()
    func useRecommendedBoxTapped()
    func shipItTapped()
    func trackingNumberEntered()
    func cancelTapped()
}

