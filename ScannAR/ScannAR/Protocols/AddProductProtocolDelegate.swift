//
//  AddProductProtocolDelegate.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

protocol AddProductProtocolDelegate: class{
    func scanWithARButtonTapped(_ sender: Any)
    func showInputScreenToInputPhotoURL()
    func saveForLaterTapped(_ sender: Any)
    func cancelButtonPressed(_ sender: Any)
    func packItButtonTapped(_ sender: Any)
    func endEditing()
    
    var manualEntryHidden: Bool { get set }
    var name: String { get set }
    var productDescription: String { get set }
    var height: Double { get set }
    var length: Double { get set }
    var width: Double { get set }
    var manufacturerId: String { get set }
    var value: Double { get set }
    var weight: Double { get set }
    var fragile: Int { get set }
}
