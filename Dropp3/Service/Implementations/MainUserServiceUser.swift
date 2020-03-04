//
//  MainUserServiceUser.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//

import Foundation

/// Main implementation of the `UserServiceUser` protocol
struct MainUserServiceUser {
  let username: String
  let password: String
}

// MARK: - UserServiceUser

extension MainUserServiceUser: UserServiceUser {
}
