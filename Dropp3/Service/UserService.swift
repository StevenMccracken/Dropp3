//
//  UserService.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/28/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

struct UserServiceError: LocalizedError {
  let code: ServiceErrorCode = .user

  enum LoginError: Int, LocalizedError {
    case unknownUsername
    case invalidCredentials
  }

  enum SignUpError: Int, LocalizedError {
    case invalidUsername
    case invalidPassword
    case existingUsername
  }
}

protocol UserService {
  /**
   Attempts to log a user in with a given username and password
   - parameter username: the user's username
   - parameter password: the user's password
   - parameter success: completion block that is called after the user is logged in
   - parameter failure: completion block that is called after a login failure
   */
  func logIn(username: String, password: String, success: (() -> Void)?, failure: @escaping (UserServiceError.LoginError) -> Void)

  /**
   Attempts to sign a user up with the given information
   - parameter username: the user's username
   - parameter password: the user's password
   - parameter firstName: the user's first name
   - parameter lastName: the user's last name
   - parameter success: completion block that is called after the user is signed up
   - parameter failure: completion block that is called after a signup failure
   */
  func signUp(username: String, password: String, firstName: String, lastName: String, success: (() -> Void)?, failure: @escaping (UserServiceError.SignUpError) -> Void)
}

/// Main implementation of the `UserService` protocol
class UserServiceAccessor: RealmProviderConsumer {
}

// MARK: - UserService

extension UserServiceAccessor: UserService {
  func logIn(username: String, password: String, success: (() -> Void)?, failure: @escaping (UserServiceError.LoginError) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
      guard let `self` = self else { return }
      let currentUser = CurrentUser(username: username,
                                    firstName: String(UUID().uuidString.split(separator: "-").first!),
                                    lastName: String(UUID().uuidString.split(separator: "-").first!))
      self.realmProvider.add(currentUser)
      success?()
    }
  }

  func signUp(username: String, password: String, firstName: String, lastName: String, success: (() -> Void)?, failure: @escaping (UserServiceError.SignUpError) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
      guard let `self` = self else { return }
      let currentUser = CurrentUser(username: username, firstName: firstName, lastName: lastName)
      self.realmProvider.add(currentUser)
      success?()
    }
  }
}
