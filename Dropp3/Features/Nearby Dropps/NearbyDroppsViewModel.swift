//
//  NearbyDroppsViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/31/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

final class NearbyDroppsViewModel {
  private var getDroppsToken: NotificationToken?
  weak var delegate: NearbyDroppsViewModelDelegate?

  deinit {
    getDroppsToken?.invalidate()
  }
}

// MARK: - NearbyDroppsViewModelProtocol

extension NearbyDroppsViewModel: NearbyDroppsViewModelProtocol {
  var dropps: Results<Dropp> {
    return realmProvider.objects(Dropp.self, predicate: nil)!
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

  func shouldRefreshData() {
    getDroppsToken?.invalidate()
    getDroppsToken = droppProvider.getDropps(around: Location(latitude: 0, longitude: 0)) { [weak self] change in
      guard let self = self else { return }
      switch change {
      case .initial:
        self.delegate?.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        self.delegate?.updateData(deletions: deletions, insertions: insertions, modifications: modifications)
      case .error(let error):
        debugPrint("An error occurred while opening the Realm file on the background worker thread: \(error)")
      }
    }
  }

}
