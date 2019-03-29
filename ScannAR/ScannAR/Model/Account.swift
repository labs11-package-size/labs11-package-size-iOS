//
//  Account.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/29/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

struct Account: Codable {
    
    var displayName: String
    var photoURL: String?
    var email: String
    var uuid: UUID
    var uid: String?
    
    // MARK: - Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        try container.encode(photoURL, forKey: .photoURL)
        try container.encode(displayName, forKey: .displayName)
    }
    
}
