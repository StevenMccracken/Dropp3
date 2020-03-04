//
//  UserServiceUser.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//

import Foundation

/// Defines necessary user information for the user service sign up API. This does not represent a valid, created user
protocol UserServiceSignUpUser: UserServiceUser {
  /// The first name of the user
  var firstName: String { get }
  /// The last name of the user
  var lastName: String { get }
}
