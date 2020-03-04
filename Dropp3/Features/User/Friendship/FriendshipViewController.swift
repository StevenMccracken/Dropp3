//
//  FriendshipViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/2/19.
//

import UIKit

final class FriendshipViewController: UIViewController {
  var status: FriendStatus = .unconnected {
    didSet {
      statusLabel?.text = status.message
      actionButtonItem?.title = status.actionMessage
    }
  }

  // MARK: - Subviews

  @IBOutlet private weak var statusLabel: UILabel!
  @IBOutlet private weak var actionButtonItem: UIBarButtonItem!
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

private extension FriendshipViewController {
  @IBAction func actionButtonAction(_ sender: UIBarButtonItem) {
    debugPrint("Friendship action button")
  }
}
