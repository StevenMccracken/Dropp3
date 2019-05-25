//
//  Location.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Location: Object, Decodable, LocationProtocol {
  var coreLocation: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }

  // MARK: - LocationProtocol

  @objc dynamic var latitude: Double = 0
  @objc dynamic var longitude: Double = 0

  // MARK: - Init

  convenience init(latitude: Double, longitude: Double) {
    self.init()
    self.latitude = latitude
    self.longitude = longitude
  }
}
