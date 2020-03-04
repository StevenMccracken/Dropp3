//
//  FriendStatus.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//

import Foundation

enum FriendStatus {
  case unconnected
  case requested
  case following

  // MARK: - Messaging

  /// - note: localized
  var message: String {
    switch self {
    case .unconnected:
      return NSLocalizedString("You don't follow them", comment: "Message indicating that the current user does not follow the other user")
    case .requested:
      return NSLocalizedString("You sent a follow request",
                               comment: "Message indicating that the current user has already sent a follow request")
    case .following:
      return NSLocalizedString("You follow them!",
                               comment: "Message indicating that the current user already follows the user in a positive exclamation")
    }
  }

  /// - note: localized
  var actionMessage: String {
    switch self {
    case .unconnected:
      return NSLocalizedString("Request to follow", comment: "Message indicating that the current user can send a follow request")
    case .requested:
      return NSLocalizedString("Remove follow request",
                               comment: "Message indicating that current user can remove an already sent follow request")
    case .following:
      return NSLocalizedString("Unfollow", comment: "Message indicating that the current user can unfollow the user")
    }
  }
}
