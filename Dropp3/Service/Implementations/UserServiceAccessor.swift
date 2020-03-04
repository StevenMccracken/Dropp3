//
//  UserServiceAccessor.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

/// Main implementation of the `UserService` protocol
class UserServiceAccessor: RealmProviderConsumer {
}

// MARK: - UserService

extension UserServiceAccessor: UserService {
  func logIn(username: String,
             password: String,
             success: (() -> Void)?,
             failure: @escaping (UserServiceError.LoginError) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(8)) { [weak self] in
      guard let self = self else { return }
      let currentUser = CurrentUser(username: username,
                                    firstName: String(UUID().uuidString.split(separator: "-").first!),
                                    lastName: String(UUID().uuidString.split(separator: "-").first!))
      self.realmProvider.add(currentUser, update: true)
      success?()
//      failure(.unknownUsername)
    }
  }

  func signUp(username: String,
              password: String,
              firstName: String,
              lastName: String,
              success: (() -> Void)?,
              failure: @escaping (UserServiceError.SignUpError) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(8)) { [weak self] in
      guard let self = self else { return }
      let currentUser = CurrentUser(username: username, firstName: firstName, lastName: lastName)
      self.realmProvider.add(currentUser, update: true)
      success?()
//      failure(.existingUsername)
    }
  }
}
