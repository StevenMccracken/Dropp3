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

class UserViewController: UIViewController {
  struct TableConstants {
    static let userSection = 0
    static let droppsSection = 1
    static let userIndexPath = IndexPath(row: 0, section: TableConstants.userSection)
  }

  // MARK: - Data

  var viewModel: UserViewModelProtocol!

  // MARK: - Views

  @IBOutlet weak var tableView: UITableView!
}

// MARK: - View lifecycle

extension UserViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    viewModel.delegate = self
    viewModel.viewDidLoad()
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
    navigationItem.title = viewModel.title
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
    return viewModel.sections
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(forSection: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case TableConstants.userSection:
      guard let infoCell = tableView.dequeueReusableCell(withIdentifier: Constants.profileCellID, for: indexPath) as? UserInfoTableViewCell else { fatalError() }
      infoCell.delegate = self
      infoCell.provide(user: viewModel.user)
      infoCell.selectionStyle = .none
      cell = infoCell
    case TableConstants.droppsSection:
      guard let droppCell = tableView.dequeueReusableCell(withIdentifier: Constants.droppCellID, for: indexPath) as? UserDroppTableViewCell else { fatalError() }
      droppCell.delegate = self
      droppCell.selectionStyle = .default
      droppCell.provide(dropp: viewModel.user.dropps[indexPath.row])
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
    locationViewController.location = viewModel.user.dropps[indexPath.row].location
    locationViewController.navigationItem.backBarButtonItem?.title = nil
    navigationController?.pushViewController(locationViewController, animated: true)
  }
}

// MARK: - UserInfoCellDelegate

extension UserViewController: UserInfoCellDelegate {
  func userInfoTableViewCell(shouldShowDroppsFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    if viewModel.user.dropps.isEmpty {
      return
    }

    tableView.scrollToRow(at: IndexPath(row: 0, section: TableConstants.droppsSection), at: .top, animated: true)
  }

  func userInfoTableViewCell(shouldShowFollowersFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    debugPrint("Show followers")
  }

  func userInfoTableViewCell(shouldShowFollowingFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    debugPrint("Show following")
  }
}

extension UserViewController: UserViewModelDelegate {
  func exitView() {
    navigationController?.popViewController(animated: true)
  }

  func reloadData() {
    tableView.reloadData()
  }

  func updateUserData() {
    tableView.reloadRows(at: [TableConstants.userIndexPath], with: .automatic)
  }

  func updateData(deletions: [Int], insertions: [Int], modifications: [Int]) {
    tableView.update(section: TableConstants.droppsSection, deletions: deletions, insertions: insertions, modifications: modifications)
  }
}
