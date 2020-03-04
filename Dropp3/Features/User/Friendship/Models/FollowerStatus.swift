//
//  FollowerStatus.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//

import Foundation

enum FollowerStatus {
  case requested
  case following

  /// - note: localized
  var actionMessage: String {
    switch self {
    case .requested:
      return NSLocalizedString("Accept or deny request",
                               comment: "Message indicating that the current user can accept or deny a given follow request")
    case .following:
      return NSLocalizedString("Remove follower", comment: "Message indicating that the current user can stop a user from following them")
    }
  }
}
