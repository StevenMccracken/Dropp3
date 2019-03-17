//
//  UserProvider.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

/// Something that provides users
protocol UserProvider: RealmProviderConsumer {
  func user(for identifier: String) -> User?
}

class MainUserProvider {
}

// MARK: - UserProvider

extension MainUserProvider: UserProvider {
  func user(for identifier: String) -> User? {
    if let user = realmProvider.object(User.self, key: identifier) {
      return user
    }

    guard let currentUser = realmProvider.object(CurrentUser.self, key: identifier), currentUser != .noUser else {
      return nil
    }

    return currentUser
  }
}
