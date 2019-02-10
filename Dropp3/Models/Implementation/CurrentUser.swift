//
//  CurrentUser.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/6/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

class CurrentUser: User {
  /// Represents a `nil` current user
  static let noUser = CurrentUser()
  let followRequests = List<User>()
  let followerRequests = List<User>()
}
