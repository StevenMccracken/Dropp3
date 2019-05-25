//
//  ServiceErrorCode.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/19/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

enum ServiceErrorCode: Int, LocalizedError {
  case user
  case dropp

  var errorDescription: String? {
    switch self {
    case .user:
      return "\(Domain.userService) :: \(rawValue)"
    case .dropp:
      return "\(Domain.droppService) :: \(rawValue)"
    }
  }
}
