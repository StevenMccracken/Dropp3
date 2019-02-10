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
  static let friendSegueID = "ViewFriendshipSegue"
  static let minimumRowHeight: CGFloat = 45
}

class UserViewController: UIViewController, RealmProviderConsumer, CurrentUserConsumer, DroppProviderConsumer {

  struct TableConstants {
    static let userSection = IndexPath(row: 0, section: 0)
  }

  // MARK: - Data

  var user: User!
  private(set) var userToken: NotificationToken?
  private(set) var droppsToken: NotificationToken?

  // MARK: - Views

  @IBOutlet weak var tableView: UITableView!

  // MARK: - Init

  deinit {
    userToken?.invalidate()
    droppsToken?.invalidate()
  }
}

// MARK: - View lifecycle

extension UserViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    userToken = user.observe { [weak self] objectChange in
      switch objectChange {
      case .deleted:
        if self?.user == self?.currentUser { return }
        self?.navigationController?.popViewController(animated: true)
      case .change(_):
        self?.tableView.reloadRows(at: [TableConstants.userSection], with: .automatic)
      case .error(let error):
        fatalError(error.localizedDescription)
      }
    }

    droppsToken = user.dropps.observe { [weak self] collectionChange in
      switch collectionChange {
      case .initial(_):
        self?.tableView.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        self?.tableView.update(section: 1, deletions: deletions, insertions: insertions, modifications: modifications)
      case .error(let error):
        fatalError(error.localizedDescription)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if segue.identifier == Constants.friendSegueID {
      guard let friendshipViewController = segue.destination as? FriendshipViewController else { fatalError() }
      friendshipViewController.status = .unconnected
    }
  }
}

// MARK: - View configuration

extension UserViewController {
  @objc func configureViews() {
    configureTableView()
    navigationItem.title = user.username
  }

  @objc func configureTableView() {
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
      return user.dropps.count
    default:
      fatalError()
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case 0:
      guard let infoCell = tableView.dequeueReusableCell(withIdentifier: Constants.profileCellID, for: indexPath) as? UserInfoTableViewCell else { fatalError() }
      infoCell.delegate = self
      infoCell.provide(user: user)
      infoCell.selectionStyle = .none
      cell = infoCell
    case 1:
      guard let droppCell = tableView.dequeueReusableCell(withIdentifier: Constants.droppCellID, for: indexPath) as? UserDroppTableViewCell else { fatalError() }
      droppCell.delegate = self
      droppCell.selectionStyle = .default
      droppCell.provide(dropp: user.dropps[indexPath.row])
      cell = droppCell
    default:
      fatalError()
    }

    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return false
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
    guard let indexPath = tableView.indexPath(for: userDroppTableViewCell) else { fatalError() }
    let locationViewController: LocationViewController = .controller()
    locationViewController.location = user.dropps[indexPath.row].location
    locationViewController.navigationItem.backBarButtonItem?.title = nil
    navigationController?.pushViewController(locationViewController, animated: true)
  }
}

// MARK: - UserInfoCellDelegate

extension UserViewController: UserInfoCellDelegate {
  func userInfoTableViewCell(shouldShowDroppsFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    if user.dropps.isEmpty {
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
