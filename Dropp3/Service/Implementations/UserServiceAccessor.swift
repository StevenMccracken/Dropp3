//
//  UserServiceAccessor.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

/// Main implementation of the `UserService` protocol
final class UserServiceAccessor: RealmProviderConsumer {
}

// MARK: - UserService

extension UserServiceAccessor: UserService {
  func logIn(user: UserServiceUser, success: (() -> Void)?, failure: @escaping (UserServiceError.Login) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(8)) { [weak self] in
      guard let self = self else { return }
      let currentUser = CurrentUser(username: user.username,
                                    firstName: String(UUID().uuidString.split(separator: "-").first!),
                                    lastName: String(UUID().uuidString.split(separator: "-").first!))
      self.realmProvider.add(currentUser, update: true)
      success?()
//      failure(.unknownUsername)
    }
  }

  func signUp(user: UserServiceSignUpUser, success: (() -> Void)?, failure: @escaping (UserServiceError.SignUp) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(8)) { [weak self] in
      guard let self = self else { return }
      let currentUser = CurrentUser(username: user.username, firstName: user.firstName, lastName: user.lastName)
      self.realmProvider.add(currentUser, update: true)
      success?()
//      failure(.existingUsername)
    }
  }
}
