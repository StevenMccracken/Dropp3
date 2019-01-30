//
//  UserViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/27/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit
import RealmSwift

private struct Constants {
  static let droppCellID = "droppCellID"
  static let profileCellID = "profileCellID"
  static let minimumRowHeight: CGFloat = 45
}

class UserViewController: UIViewController, ContainerConsumer {

  // MARK: - Data

  var user: User!
  private var token: NotificationToken?
  private var realmProvider: RealmProvider!

  private var dropps: List<Dropp> {
    return user.dropps
  }

  // MARK: - Views

  @IBOutlet private weak var tableView: UITableView!

  // MARK: - Init

  deinit {
    token?.invalidate()
  }
}

// MARK: - View lifecycle

extension UserViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    resolveDepedencies()
    configureViews()
  }
}

// MARK: - View configuration

extension UserViewController {
  private func configureViews() {
    configureTableView()
    navigationItem.title = user.username
  }

  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(UserDroppTableViewCell.nib, forCellReuseIdentifier: Constants.droppCellID)
    tableView.register(UserInfoTableViewCell.nib, forCellReuseIdentifier: Constants.profileCellID)
  }
}

// MARK: - UITableViewDataSource

extension UserViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return dropps.count
    default:
      fatalError()
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case 0:
      guard let infoCell = tableView.dequeueReusableCell(withIdentifier: Constants.profileCellID, for: indexPath) as? UserInfoTableViewCell else {
        fatalError()
      }

      infoCell.delegate = self
      infoCell.provide(user: user)
      infoCell.selectionStyle = .none
      cell = infoCell
    case 1:
      guard let droppCell = tableView.dequeueReusableCell(withIdentifier: Constants.droppCellID, for: indexPath) as? UserDroppTableViewCell else {
        fatalError()
      }

      droppCell.delegate = self
      droppCell.selectionStyle = .default
      droppCell.provide(dropp: dropps[indexPath.row])
      cell = droppCell
    default:
      fatalError()
    }

    return cell
  }
}

// MARK: - UITableViewDelegate

extension UserViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - UserDroppCellDelegate

extension UserViewController: UserDroppCellDelegate {
  func userDroppTableViewCell(shouldShowLocationFromCell userDroppTableViewCell: UserDroppTableViewCell) {
    guard let locationViewController = UIStoryboard(name: "LocationView", bundle: .main).instantiateInitialViewController() as? LocationViewController,
      let indexPath = tableView.indexPath(for: userDroppTableViewCell) else {
        fatalError()
    }

    locationViewController.location = dropps[indexPath.row].location
    navigationController?.pushViewController(locationViewController, animated: true)
  }

}

// MARK: - UserInfoCellDelegate

extension UserViewController: UserInfoCellDelegate {
  func userInfoTableViewCell(shouldShowDroppsFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    if dropps.isEmpty {
      return
    }

    tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
  }

  func userInfoTableViewCell(shouldShowFollowersFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    debugPrint("Show followers")
  }

  func userInfoTableViewCell(shouldShowFollowingFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    debugPrint("Show following")
  }

}

// MARK: - DependencyContaining

extension UserViewController: DependencyContaining {
  func resolveDepedencies() {
    realmProvider = container.resolve(RealmProvider.self)
  }
}
