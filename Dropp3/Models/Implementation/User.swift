//
//  User.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/27/19.
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

  // TODO: remove
  static func random() -> User {
    let names = (1...3).map { _ in return String(UUID().uuidString.split(separator: "-").first!) }
    return User(username: names[0], firstName: names[1], lastName: names[2])
  }

  // MARK: - Realm primary key

  override static func primaryKey() -> String? {
    return "identifier"
  }
}

// MARK: - NSCopying

extension User: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    let user = User(username: username, firstName: firstName, lastName: lastName)
    user.identifier = identifier
    return user
  }
}

// MARK: - Equatable

extension User {
  static func == (lhs: User, rhs: User) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
