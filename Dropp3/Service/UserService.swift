//
//  UserService.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/28/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserService {
  func logIn(username: String, password: String, success: (() -> Void)?, failure: @escaping (Error) -> Void)
  func signUp(username: String, password: String, firstName: String, lastName: String, success: (() -> Void)?, failure: @escaping (Error) -> Void)
}

private struct Constants {
  static let errorCode = 1
  static let domain = "com.dropp.userService"
}

class UserServiceAccessor: RealmProviderConsumer {
}

extension UserServiceAccessor: UserService {
  func logIn(username: String, password: String, success: (() -> Void)?, failure: @escaping (Error) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
      guard let `self` = self else { return }
      let currentUser = CurrentUser(username: username,
                                    firstName: String(UUID().uuidString.split(separator: "-").first!),
                                    lastName: String(UUID().uuidString.split(separator: "-").first!))
      self.realmProvider.add(currentUser)
      success?()
    }
  }

  func signUp(username: String, password: String, firstName: String, lastName: String, success: (() -> Void)?, failure: @escaping (Error) -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
      guard let `self` = self else { return }
      let currentUser = CurrentUser(username: username, firstName: firstName, lastName: lastName)
      self.realmProvider.add(currentUser)
      success?()
    }
  }
}
