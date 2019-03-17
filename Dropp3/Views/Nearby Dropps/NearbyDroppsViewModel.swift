//
//  NearbyDroppsViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/31/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

protocol NearbyDroppsViewModelDelegate: AnyObject {
  func reloadData()
  func updateData(deletions: [Int], insertions: [Int], modifications: [Int])
}

protocol NearbyDroppsViewModelProtocol: RealmProviderConsumer, DroppProviderConsumer {
  var dropps: Results<Dropp> { get }
  var delegate: NearbyDroppsViewModelDelegate? { get set }

  func viewDidLoad()
  func shouldRefreshData()
  func shouldPerformEditAction(atRow row: Int)
  func title(forEditActionAtRow row: Int) -> String
  func controller(forRow row: Int) -> UserViewController
}

class NearbyDroppsViewModel {
  private var token: NotificationToken?
  var delegate: NearbyDroppsViewModelDelegate?

  deinit {
    token?.invalidate()
  }
}

// MARK: - NearbyDroppsViewModelProtocol

extension NearbyDroppsViewModel: NearbyDroppsViewModelProtocol {
  var dropps: Results<Dropp> {
    return realmProvider.objects(Dropp.self)!
  }

  func viewDidLoad() {
    shouldRefreshData()
  }

  func title(forEditActionAtRow row: Int) -> String {
    return dropps[row].hidden ? "Unhide" : "Hide"
  }

  func controller(forRow row: Int) -> UserViewController {
    let userID: String! = dropps[row].userID
    let userViewController: UserViewController
    if let currentUser = realmProvider.object(CurrentUser.self, key: userID) {
      let currentUserViewController: CurrentUserViewController = .controller()
      currentUserViewController.currentUserViewModel = CurrentUserViewModel(user: currentUser)
      userViewController = currentUserViewController
    } else {
      let user = realmProvider.object(User.self, key: userID)!
      userViewController = .controller()
      userViewController.viewModel = UserViewModel(user: user)
    }

    return userViewController
  }

  func shouldPerformEditAction(atRow row: Int) {
    let dropp = dropps[row]
    realmProvider.runTransaction {
      dropp.hidden.toggle()
    }
  }

  func shouldRefreshData() {
    token?.invalidate()
    token = droppProvider.getDropps(around: Location(latitude: 0, longitude: 0)) { [weak self] collectionChange in
      switch collectionChange {
      case .initial(_):
        self?.delegate?.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        self?.delegate?.updateData(deletions: deletions, insertions: insertions, modifications: modifications)
      case .error(let error):
        // An error occurred while opening the Realm file on the background worker thread
        fatalError("\(error)")
      }
    }
  }

}
