//
//  MainUserProvider.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

final class MainUserProvider {
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
