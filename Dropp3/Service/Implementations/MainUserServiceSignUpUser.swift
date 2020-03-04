//
//  MainUserServiceSignUpUser.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//

import Foundation

/// Main implementation of the `UserServiceSignUpUser` protocol
struct MainUserServiceSignUpUser {
  let firstName: String
  let lastName: String
  let username: String
  let password: String
}

// MARK: - UserServiceSignUpUser

extension MainUserServiceSignUpUser: UserServiceSignUpUser {
}
