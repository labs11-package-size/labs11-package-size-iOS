//
//  URL+Secure.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/10/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}
