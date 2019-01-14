//
//  Dropp.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

struct Dropp {
    let identifier: String
    let username: String
    let message: String
    let hasImage: Bool
    let location : Location

    init(username: String, location: Location, hasImage: Bool, message: String) {
        self.message = message
        self.username = username
        self.location = location
        self.hasImage = hasImage
        identifier = UUID().uuidString
    }
}

// MARK: - Codable

extension Dropp: Codable {
}
