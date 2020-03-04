//
//  MainViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/27/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit
import RealmSwift

final class MainViewController: UINavigationController, RealmProviderConsumer, CurrentUserConsumer {
  private var currentUserToken: NotificationToken?
  private var shouldShowWelcomeView = false {
    didSet {
      if shouldShowWelcomeView {
        showWelcomeView()
      } else {
        showNearbyView()
      }
    }
  }

  deinit {
    currentUserToken?.invalidate()
  }
}

// MARK: - View lifecycle

extension MainViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    currentUserToken = realmProvider.observe(resultsForType: CurrentUser.self, withPredicate: nil) { [weak self] in
      switch $0 {
      case .initial:
        self?.shouldShowWelcomeView = self?.currentUser == nil
      case .update(_, let deletions, let insertions, _):
        if !insertions.isEmpty {
          // new current user registered
          self?.shouldShowWelcomeView = false
          self?.dismiss(animated: true, completion: nil)
        } else if !deletions.isEmpty {
          // current user de-registered
          self?.shouldShowWelcomeView = true
        } else {
          debugPrint("Current user was updated")
        }
      case .error(let error):
        debugPrint("Received error while subscribing to CurrentUser updates: \(error.localizedDescription)")
      }
    }
  }
}

// MARK: - View configuration

private extension MainViewController {
  func showWelcomeView() {
    let welcomeViewController: WelcomeViewController = .controller()
    welcomeViewController.isModalInPresentation = true
    let navigationController = UINavigationController(rootViewController: welcomeViewController)
    children.first?.present(navigationController, animated: true) { [weak self] in
      self?.setViewControllers([.controller(from: "LaunchScreen", bundle: .main)], animated: true)
    }
  }

  func showNearbyView() {
    let nearbyDroppsViewController: NearbyDroppsViewController = .controller()
    let navigationItem = nearbyDroppsViewController.navigationItem
    let profileTitle = NSLocalizedString("Profile", comment: "Button routing the user to view their own profile")
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: profileTitle,
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(profileAction(_:)))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(postAction(_:)))
    setViewControllers([nearbyDroppsViewController], animated: true)
  }
}

// MARK: - Actions

// TODO: Remove DroppProviderConsumer conformance and make extension private
extension MainViewController: DroppProviderConsumer {
  @objc private func profileAction(_ sender: UIBarButtonItem) {
    let profileViewController: CurrentUserViewController = .controller()
    profileViewController.didPresentViewController = true
    profileViewController.currentUserViewModel = CurrentUserViewModel(user: currentUser!)
    let navigationController = UINavigationController(rootViewController: profileViewController)
    navigationController.isToolbarHidden = false
    present(navigationController, animated: true, completion: nil)
  }

  // TODO: Delete
  @objc private func postAction(_ sender: UIBarButtonItem) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    droppProvider.addDroppForRandomUser()
    generator.notificationOccurred(.success)
  }
}
