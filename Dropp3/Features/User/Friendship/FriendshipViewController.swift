//
//  FriendshipViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/2/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

enum FriendStatus {
  case unconnected
  case requested
  case following

  // MARK: - Messaging

  /// - note: localized
  var message: String {
    switch self {
    case .unconnected:
      return NSLocalizedString("You don't follow them",
                               comment: "Message indicating that the current user does not follow the other user")
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
      return NSLocalizedString("Request to follow",
                               comment: "Message indicating that the current user can send a follow request")
    case .requested:
      return NSLocalizedString("Remove follow request",
                               comment: "Message indicating that current user can remove an already sent follow request")
    case .following:
      return NSLocalizedString("Unfollow", comment: "Message indicating that the current user can unfollow the user")
    }
  }
}

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
      return NSLocalizedString("Remove follower",
                               comment: "Message indicating that the current user can stop a user from following them")
    }
  }
}

class FriendshipViewController: UIViewController {
  var status: FriendStatus! {
    didSet {
      statusLabel?.text = status.message
      actionButtonItem?.title = status.actionMessage
    }
  }

  // MARK: - Outlets

  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var actionButtonItem: UIBarButtonItem!
}

// MARK: - View lifecycle

extension FriendshipViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    correctAlignment(for: traitCollection)
    statusLabel.text = status.actionMessage
    actionButtonItem.title = status.actionMessage
  }

  override func willTransition(to newCollection: UITraitCollection,
                               with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    coordinator.animate(alongsideTransition: { [weak self] _ in
        self?.correctAlignment(for: newCollection)
    }, completion: nil)
  }

  private func correctAlignment(for traitCollection: UITraitCollection) {
    statusLabel.textAlignment = traitCollection.verticalSizeClass == .compact ? .left : .center
  }
}

// MARK: - Actions

extension FriendshipViewController {
  @IBAction private func actionButtonAction(_ sender: UIBarButtonItem) {
  }
}
