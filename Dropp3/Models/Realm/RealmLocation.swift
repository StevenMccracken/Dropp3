//
//  RealmLocation.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLocation: Object {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0

    convenience init(location: Location) {
        self.init()
        latitude = location.latitude
        longitude = location.longitude
    }
}
