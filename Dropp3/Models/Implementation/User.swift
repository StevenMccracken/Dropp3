//
//  User.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/27/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {

  @objc dynamic var username: String = ""
  @objc dynamic var identifier: String = ""
  @objc dynamic var firstName: String = ""
  @objc dynamic var lastName: String = ""
  let dropps = List<Dropp>()
  let followers = List<User>()
  let following = List<User>()

  var fullName: String {
    return "\(firstName) \(lastName)"
  }

  // MARK: - Init

  convenience init(username: String, firstName: String, lastName: String) {
    self.init()
    self.username = username
    self.firstName = firstName
    self.lastName = lastName
    identifier = UUID().uuidString
  }

  // MARK: - Realm primary key

  override static func primaryKey() -> String? {
    return "identifier"
  }
}
