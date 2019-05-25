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

  enum Section: Int, CaseIterable {
    case user
    case dropps
  }

  // MARK: - Private data

  private(set) var tokens: Set<NotificationToken> = []

  // MARK: - Init

  init(user: User) {
    self.user = user
  }

  deinit {
    tokens.forEach { $0.invalidate() }
  }

  func didRefreshData() {
    // no-op
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

  @objc func viewDidLoad() {
    shouldRefreshData()
  }

  func shouldRefreshData() {
    tokens.forEach { $0.invalidate() }
    tokens.removeAll()
    let droppsToken = user.dropps.observe { [weak self] collectionChange in
      switch collectionChange {
      case .initial(_):
        self?.delegate?.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        self?.delegate?.updateData(deletions: deletions, insertions: insertions, modifications: modifications)
      case .error(let error):
        fatalError(error.localizedDescription)
      }

      self?.didRefreshData()
    }

    let userToken = user.observe { [weak self] objectChange in
      switch objectChange {
      case .deleted:
        if self?.user == self?.currentUser { return }
        self?.delegate?.exitView()
      case .change(_):
        self?.delegate?.updateUserData()
        self?.didRefreshData()
      case .error(let error):
        fatalError(error.localizedDescription)
      }
    }

    [userToken, droppsToken].forEach { tokens.insert($0) }
  }
}
