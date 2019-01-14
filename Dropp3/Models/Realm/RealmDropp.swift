//
//  RealmDropp.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDropp: Object {
    @objc dynamic var identifier: String?
    @objc dynamic var username: String = ""
    @objc dynamic var message: String = ""
    @objc dynamic var hasImage: Bool = false
    @objc dynamic var location: RealmLocation?

    convenience init(dropp: Dropp) {
        self.init()
        message = dropp.message
        hasImage = dropp.hasImage
        username = dropp.username
        identifier = dropp.identifier
        location = RealmLocation(location: dropp.location)
    }

    override static func primaryKey() -> String? {
        return "identifier"
    }
}
