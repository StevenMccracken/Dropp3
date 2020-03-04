//
//  UserServiceUser.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//

import Foundation

/// Defines necessary user information for certain user service APIs. This does not represent a valid, created user
protocol UserServiceUser {
  /// The username of the user
  var username: String { get }
  /// The password of the user
  var password: String { get }
}
