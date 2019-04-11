//
//  Cache.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/10/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class Cache<Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    func clear() {
        queue.async {
            self.cache.removeAll()
        }
    }
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "com.LambdaSchool.ScannAR.CacheQueue")
}
