//
//  UserServiceError.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//

import Foundation

struct UserServiceError: LocalizedError {
  let code: ServiceErrorCode = .user

  enum Login: Int, LocalizedError {
    case unknownUsername = 101
    case invalidCredentials = 102
  }

  enum SignUp: Int, LocalizedError {
    case invalidUsername = 151
    case invalidPassword = 152
    case existingUsername = 153
  }
}
