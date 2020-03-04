//
//  UserViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/27/19.
//

import UIKit
import RealmSwift

class UserViewController: UIViewController {
  // MARK: - Constants

  // swiftlint:disable convenience_type
  struct Constants {
    struct Table {
      static let userSection = 0
      static let droppsSection = 1
      static let userIndexPath = IndexPath(row: 0, section: userSection)
    }
    struct CellID {
      static let dropp = UUID().uuidString
      static let profile = UUID().uuidString
    }
    enum Segue: String {
      case viewFriendship = "ViewFriendshipSegue"
    }
  }
  // swiftlint:enable convenience_type

  // MARK: - Data

  var viewModel: UserViewModelProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  // MARK: - Views

  @IBOutlet weak var tableView: UITableView!
}

// MARK: - View lifecycle

extension UserViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    viewModel.delegate = self
    viewModel.shouldRefreshData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    guard let segueConstant = Constants.Segue(rawValue: segue.identifier ?? "") else {
      debugPrint("Encountered segue with unrecognized identifier: \(segue.identifier ?? "")")
      return
    }

    switch segueConstant {
    case .viewFriendship:
      guard let friendshipViewController = segue.destination as? FriendshipViewController else {
        debugPrint("Invalid destination for Constants.Segue.viewFriendship")
        return
      }
      friendshipViewController.status = .unconnected
    }
  }
}

// MARK: - View configuration

extension UserViewController {
  @objc
  func configureViews() {
    configureTableView()
    navigationItem.title = viewModel.title
  }

  @objc
  func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(UserDroppTableViewCell.nib, forCellReuseIdentifier: Constants.CellID.dropp)
    tableView.register(UserInfoTableViewCell.nib, forCellReuseIdentifier: Constants.CellID.profile)
  }
}

// MARK: - UITableViewDataSource

extension UserViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int { viewModel.sections }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.numberOfRows(forSection: section) }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case Constants.Table.userSection:
      guard let infoCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellID.profile,
                                                         for: indexPath) as? UserInfoTableViewCell else {
                                                          fatalError("Invalid reusable cell for index path: \(indexPath)")
      }
      infoCell.delegate = self
      infoCell.provide(user: viewModel.user)
      infoCell.selectionStyle = .none
      cell = infoCell
    case Constants.Table.droppsSection:
      guard let droppCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellID.dropp,
                                                          for: indexPath) as? UserDroppTableViewCell else {
                                                            fatalError("Invalid reusable cell for index path: \(indexPath)")
      }
      droppCell.delegate = self
      droppCell.selectionStyle = .default
      droppCell.provide(dropp: viewModel.user.dropps[indexPath.row])
      cell = droppCell
    default:
      fatalError("Encountered unexpected index path section: \(indexPath.section)")
    }

    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { false }
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
    guard let indexPath = tableView.indexPath(for: userDroppTableViewCell) else {
      debugPrint("Unable to find index path for given cell")
      return
    }
    let locationViewController: LocationViewController = .controller()
    locationViewController.location = viewModel.user.dropps[indexPath.row].location
    locationViewController.navigationItem.backBarButtonItem?.title = nil
    navigationController?.pushViewController(locationViewController, animated: true)
  }
}

// MARK: - UserInfoCellDelegate

extension UserViewController: UserInfoCellDelegate {
  func userInfoTableViewCell(shouldShowDroppsFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    if !viewModel.user.dropps.isEmpty {
      tableView.scrollToRow(at: IndexPath(row: 0, section: Constants.Table.droppsSection), at: .top, animated: true)
    }
  }

  func userInfoTableViewCell(shouldShowFollowersFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    debugPrint("Show followers")
  }

  func userInfoTableViewCell(shouldShowFollowingFromCell userInfoTableViewCell: UserInfoTableViewCell) {
    debugPrint("Show following")
  }
}

// MARK: - UserViewModelDelegate

extension UserViewController: UserViewModelDelegate {
  func exitView() {
    navigationController?.popViewController(animated: true)
  }

  func reloadData() {
    tableView.reloadData()
  }

  func updateUserData() {
    tableView.reloadRows(at: [Constants.Table.userIndexPath], with: .automatic)
  }

  func updateData(deletions: [Int], insertions: [Int], modifications: [Int]) {
    tableView.update(section: Constants.Table.droppsSection,
                     deletions: deletions,
                     insertions: insertions,
                     modifications: modifications)
  }
}
