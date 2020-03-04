//
//  UserService.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/28/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserService {
  /**
   Attempts to log in a given user
   - parameter user: the user to attempt the log in for
   - parameter success: completion block that is called after the user is logged in
   - parameter failure: completion block that is called after a login failure
   */
  func logIn(user: UserServiceUser,
             success: (() -> Void)?,
             failure: @escaping (UserServiceError.LoginError) -> Void)

  /**
   Attempts to sign up a given user
   - parameter user: the user to attempt the sign up for
   - parameter success: completion block that is called after the user is signed up
   - parameter failure: completion block that is called after a signup failure
   */
  func signUp(user: UserServiceSignUpUser,
              success: (() -> Void)?,
              failure: @escaping (UserServiceError.SignUpError) -> Void)
}
