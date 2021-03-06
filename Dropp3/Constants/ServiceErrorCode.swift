//
//  ServiceErrorCode.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/19/19.
//

import Foundation

enum ServiceErrorCode: Int, LocalizedError {
  case user = 100
  case dropp = 200

  var errorDescription: String? {
    switch self {
    case .user:
      return "\(Domain.userService) :: \(rawValue)"
    case .dropp:
      return "\(Domain.droppService) :: \(rawValue)"
    }
  }
}
