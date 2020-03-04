//
//  Dropp.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

class Dropp: Object {
  @objc dynamic var message: String = ""
  @objc dynamic var hasImage: Bool = false
  @objc dynamic var identifier: String = ""
  @objc dynamic var userID: String?
  @objc dynamic var location: Location?

  // MARK: - Init

  convenience init(userID: String, location: Location, hasImage: Bool, message: String) {
    self.init()
    self.userID = userID
    self.message = message
    self.hasImage = hasImage
    self.location = location
    identifier = UUID().uuidString
  }

  // MARK: - Realm primary key

  override static func primaryKey() -> String? {
    return "identifier"
  }
}
