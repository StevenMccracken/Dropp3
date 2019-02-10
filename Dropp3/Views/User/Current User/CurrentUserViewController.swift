//
//  CurrentUserViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

class CurrentUserViewController: UserViewController {
  private lazy var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction(_:)))
  private lazy var deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAction(_:)))
  private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
  private lazy var logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutAction(_:)))
  private lazy var profileButton = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(profileAction(_:)))

  private lazy var selectedRowsForDeletion: Set<IndexPath> = []
}

// MARK: - View lifecycle

extension CurrentUserViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - View configuration

extension CurrentUserViewController {
  override func configureViews() {
    super.configureViews()
    navigationItem.title = "You"
    setEditing(false, animated: false)
    droppProvider.addDroppForCurrentUser()
  }

  override func configureTableView() {
    super.configureTableView()
    tableView.tintColor = .primary
    tableView.allowsMultipleSelectionDuringEditing = true
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(editing, animated: animated)
    navigationItem.setHidesBackButton(editing, animated: animated)

    let toolbarItems: [UIBarButtonItem]
    if isEditing {
      deleteButton.isEnabled = false
      toolbarItems = [deleteButton, .flexibileSpace, cancelButton]
    } else {
      toolbarItems = [logoutButton, .flexibileSpace, profileButton, .flexibileSpace, editButton]
    }

    setToolbarItems(toolbarItems, animated: animated)
  }
}

// MARK: - Table management

extension CurrentUserViewController {
  private func validateDeletionState() {
    deleteButton.isEnabled = !selectedRowsForDeletion.isEmpty
  }

  private func reloadUserInfo() {
    tableView.reloadRows(at: [TableConstants.userSection], with: .automatic)
  }

  private func deleteRows(at indexPaths: [IndexPath], refreshUserInfo: Bool = true) {
    tableView.performBatchUpdates({ [weak self] in
      self?.tableView.deleteRows(at: indexPaths, with: .automatic)
      if refreshUserInfo {
        self?.reloadUserInfo()
      }
    }, completion: nil)
  }


  private func endEditing() {
    selectedRowsForDeletion.removeAll()
    setEditing(false, animated: true)
    tableView.insertRows(at: [TableConstants.userSection], with: .top)
  }
}

// MARK: - Actions

extension CurrentUserViewController {
  @objc private func editAction(_ sender: UIBarButtonItem) {
    setEditing(true, animated: true)
    tableView.deleteRows(at: [TableConstants.userSection], with: .top)
  }

  @objc private func cancelAction(_ sender: UIBarButtonItem) {
    endEditing()
  }

  @objc private func deleteAction(_ sender: UIBarButtonItem) {
    let dropps: [Dropp] = selectedRowsForDeletion.map { user.dropps[$0.row] }
    realmProvider.runTransaction(withoutNotifying: [droppsToken, userToken]) { [weak self] in
      guard let `self` = self else { return }
      dropps.forEach { dropp in
        let index: Int! = self.user.dropps.firstIndex(of: dropp)
        self.user.dropps.remove(at: index)
      }

      self.deleteRows(at: Array(selectedRowsForDeletion), refreshUserInfo: false)
    }

    realmProvider.delete(dropps)
    endEditing()
  }

  @objc private func logOutAction(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Log out?", message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
      guard let `self` = self, let user = self.currentUser else { return }
      self.realmProvider.delete(user)
    }))

    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alertController.present(from: self, barButtonItem: sender, sourceView: nil, animated: true, completion: nil)
  }

  @objc private func profileAction(_ sender: UIBarButtonItem) {
  }
}

// MARK: - UITableViewDataSource

extension CurrentUserViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard isEditing else { return super.tableView(tableView, numberOfRowsInSection: section) }
    switch section {
    case 0:
      return 0
    case 1:
      return user.dropps.count
    default:
      fatalError()
    }
  }
}

// MARK: - UITableViewDelegate

extension CurrentUserViewController {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    if isEditing { return nil }
    let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { [weak self] (_, indexPath) in
      let dropp: Dropp! = self?.user.dropps[indexPath.row]
      self?.realmProvider.runTransaction(withoutNotifying: [self?.droppsToken, self?.userToken]) {
        self?.user.dropps.remove(at: indexPath.row)
        self?.deleteRows(at: [indexPath])
      }

      self?.realmProvider.delete(dropp)
    }

    deleteAction.backgroundColor = .buttonBackground
    return [deleteAction]
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section > 0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard isEditing else {
      super.tableView(tableView, didSelectRowAt: indexPath)
      return
    }

    selectedRowsForDeletion.insert(indexPath)
    validateDeletionState()
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard isEditing else { return }
    selectedRowsForDeletion.remove(indexPath)
    validateDeletionState()
  }
}
