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

  private lazy var editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                                target: self,
                                                action: #selector(editAction(_:)))
  private lazy var deleteButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                                  target: self,
                                                  action: #selector(deleteAction(_:)))
  private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancelAction(_:)))
  private lazy var logoutButton: UIBarButtonItem = {
    let title = NSLocalizedString("Logout", comment: "Button prompting the user to log out")
    let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(logOutAction(_:)))
    return button
  }()

  private lazy var profileButton: UIBarButtonItem = {
    let title = NSLocalizedString("More", comment: "Button routing the user to more configuration options")
    let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(profileAction(_:)))
    return button
  }()

  private lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(doneAction(_:)))
  private lazy var postButton: UIBarButtonItem = {
    let title = NSLocalizedString("Post", comment: "Button prompting the user to create a new dropp")
    let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(postAction(_:)))
    return button
  }()

  // MARK: - Public data

  /// Default is `false`
  var didPresentViewController: Bool = false

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
  }

  @objc private func postAction(_ sender: UIBarButtonItem) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    MainDroppProvider().addDroppForCurrentUser()
    generator.notificationOccurred(.success)
  }
}

// MARK: - View configuration

extension CurrentUserViewController {
  override func configureViews() {
    super.configureViews()
    navigationItem.rightBarButtonItem = postButton
    if didPresentViewController {
      navigationItem.leftBarButtonItem = doneButton
    }

    setEditing(false, animated: false)
  }

  override func configureTableView() {
    super.configureTableView()
    tableView.tintColor = .primary
    tableView.allowsMultipleSelectionDuringEditing = true
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    isModalInPresentation = editing
    tableView.setEditing(editing, animated: animated)
    postButton.isEnabled = !editing
    if didPresentViewController {
      doneButton.isEnabled = !editing
    } else {
      navigationItem.setHidesBackButton(editing, animated: animated)
    }

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

    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    endEditing()
    generator.notificationOccurred(.success)
  }

  @objc private func logOutAction(_ sender: UIBarButtonItem) {
    let logOutTitle = NSLocalizedString("Log out?", comment: "Question confirming if the user wants to log out")
    let alertController = UIAlertController(title: logOutTitle, message: nil, preferredStyle: .actionSheet)
    let yesTitle = NSLocalizedString("Yes", comment: "Button confirming the log out action")
    alertController.addAction(UIAlertAction(title: yesTitle, style: .destructive, handler: { [weak self] _ in
      self?.currentUserViewModel.shouldLogOut()
    }))

    let cancelTitle = NSLocalizedString("Cancel", comment: "Button canceling the log out action")
    alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    alertController.present(from: self, barButtonItem: sender, sourceView: nil, animated: true, completion: nil)
    generator.notificationOccurred(.warning)
  }

  @objc private func profileAction(_ sender: UIBarButtonItem) {
  }

  @objc private func doneAction(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
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
    let deleteTitle = NSLocalizedString("Delete", comment: "Button prompting the user to delete the item")
    let deleteAction = UITableViewRowAction(style: .default, title: deleteTitle) { [weak self] (_, indexPath) in
      self?.currentUserViewModel.deleteDropp(atIndex: indexPath.row) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        self?.deleteRows(at: [indexPath])
        generator.notificationOccurred(.success)
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
  func toggleEditButton(enabled: Bool) {
    editButton.isEnabled = enabled
  }

  func toggleDeleteButton(enabled: Bool) {
    deleteButton.isEnabled = enabled
  }
}
