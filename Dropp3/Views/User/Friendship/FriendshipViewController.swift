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

  var message: String {
    switch self {
    case .unconnected:
      return "You don't follow them"
    case .requested:
      return "You sent a follow request"
    case .following:
      return "You follow them!"
    }
  }

  var actionMessage: String {
    switch self {
    case .unconnected:
      return "Request to follow"
    case .requested:
      return "Remove follow request"
    case .following:
      return "Unfollow"
    }
  }
}

enum FollowerStatus {
  case requested
  case following

  var actionMessage: String {
    switch self {
    case .requested:
      return "Accept or deny request"
    case .following:
      return "Remove follower"
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

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
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
