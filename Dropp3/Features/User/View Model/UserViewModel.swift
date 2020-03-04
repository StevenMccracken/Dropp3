//
//  UserViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

class UserViewModel: CurrentUserConsumer {
  // MARK: - Public data

  let user: User
  weak var delegate: UserViewModelDelegate?
  private(set) var observationTokens: Set<NotificationToken> = []

  // MARK: - Private data

  private enum Section: Int, CaseIterable {
    case user
    case dropps
  }

  // MARK: - Object lifecycle

  init(user: User) {
    self.user = user
  }

  deinit {
    observationTokens.forEach { $0.invalidate() }
  }
}

// MARK: - UserViewModelProtocol

extension UserViewModel: UserViewModelProtocol {
  @objc var title: String {
    return user.username
  }

  var sections: Int {
    return Section.allCases.count
  }

  func numberOfRows(forSection section: Int) -> Int {
    guard let viewSection = Section(rawValue: section) else { fatalError("Invalid section: \(section)") }
    let rows: Int
    switch viewSection {
    case .user:
      rows = 1
    case .dropps:
      rows = user.dropps.count
    }

    return rows
  }

  func shouldRefreshData() {
    observationTokens.forEach { $0.invalidate() }
    observationTokens.removeAll()
    let droppsToken = user.dropps.observe { [weak self] collectionChange in
      switch collectionChange {
      case .initial:
        self?.delegate?.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        self?.delegate?.updateData(deletions: deletions, insertions: insertions, modifications: modifications)
      case .error(let error):
        debugPrint("Received error while observing user dropps collection: \(error.localizedDescription)")
      }

      self?.didRefreshData()
    }

    let userToken = user.observe { [weak self] objectChange in
      switch objectChange {
      case .deleted:
        if self?.user == self?.currentUser { return }
        self?.delegate?.exitView()
      case .change:
        self?.delegate?.updateUserData()
        self?.didRefreshData()
      case .error(let error):
        debugPrint("Received error while observing user: \(error.localizedDescription)")
      }
    }

    [userToken, droppsToken].forEach { observationTokens.insert($0) }
  }

  @objc func didRefreshData() {
    // no-op
  }
}
