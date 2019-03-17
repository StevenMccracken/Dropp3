//
//  CurrentUserViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

class CurrentUserViewController: UserViewController {

  // MARK: - Buttons

  private lazy var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction(_:)))
  private lazy var deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAction(_:)))
  private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
  private lazy var logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutAction(_:)))
  private lazy var profileButton = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(profileAction(_:)))

  // MARK: - Public data

  var currentUserViewModel: CurrentUserViewModelProtocol! {
    didSet {
      viewModel = currentUserViewModel
    }
  }
}

// MARK: - View lifecycle

extension CurrentUserViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    currentUserViewModel.currentUserViewDelegate = self
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postAction(_:)))
  }

  @objc private func postAction(_ sender: UIBarButtonItem) {
    MainDroppProvider().addDroppForCurrentUser()
  }
}

// MARK: - View configuration

extension CurrentUserViewController {
  override func configureViews() {
    super.configureViews()
    setEditing(false, animated: false)
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
  private func deleteRows(at indexPaths: [IndexPath], refreshUserInfo: Bool = true) {
    tableView.performBatchUpdates({ [weak self] in
      self?.tableView.deleteRows(at: indexPaths, with: .automatic)
      if refreshUserInfo {
        self?.tableView.reloadRows(at: [TableConstants.userIndexPath], with: .automatic)
      }
    }, completion: nil)
  }


  private func endEditing() {
    currentUserViewModel.finishEditing()
    setEditing(false, animated: true)
    tableView.insertRows(at: [TableConstants.userIndexPath], with: .top)
  }
}

// MARK: - Actions

extension CurrentUserViewController {
  @objc private func editAction(_ sender: UIBarButtonItem) {
    setEditing(true, animated: true)
    tableView.deleteRows(at: [TableConstants.userIndexPath], with: .top)
  }

  @objc private func cancelAction(_ sender: UIBarButtonItem) {
    endEditing()
  }

  @objc private func deleteAction(_ sender: UIBarButtonItem) {
    currentUserViewModel.deleteSelectedDropps { rows in
      let indexPaths = rows.map { IndexPath(row: $0, section: TableConstants.droppsSection) }
      deleteRows(at: indexPaths, refreshUserInfo: false)
    }

    endEditing()
  }

  @objc private func logOutAction(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Log out?", message: nil, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
      self?.currentUserViewModel.shouldLogOut()
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
    switch section {
    case 0:
      return isEditing ? 0 : super.tableView(tableView, numberOfRowsInSection: section)
    case 1:
      return super.tableView(tableView, numberOfRowsInSection: section)
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
      self?.currentUserViewModel.deleteDropp(atIndex: indexPath.row) {
        self?.deleteRows(at: [indexPath])
      }
    }

    deleteAction.backgroundColor = .buttonBackground
    return [deleteAction]
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section > 0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isEditing {
      currentUserViewModel.add(deletedRow: indexPath.row)
    } else {
      super.tableView(tableView, didSelectRowAt: indexPath)
    }
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard isEditing else { return }
    currentUserViewModel.remove(deletedRow: indexPath.row)
  }
}

// MARK: - CurrentUserViewDelegate

extension CurrentUserViewController: CurrentUserViewDelegate {
  func toggleDeleteButton(enabled: Bool) {
    deleteButton.isEnabled = enabled
  }
}
