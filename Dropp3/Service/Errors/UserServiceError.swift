//
//  UserServiceError.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
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
