//
//  Array+Extension.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/6/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}
