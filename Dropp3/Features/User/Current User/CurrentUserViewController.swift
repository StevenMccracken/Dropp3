//
//  CurrentUserViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//

import UIKit

final class CurrentUserViewController: UserViewController {
  // MARK: - Buttons

  private lazy var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction(_:)))
  private lazy var deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAction(_:)))
  private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
  private lazy var logoutButton = UIBarButtonItem(title: NSLocalizedString("Logout", comment: "Button prompting the user to log out"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(logOutAction(_:)))
  private lazy var profileButton = UIBarButtonItem(title: NSLocalizedString("More", comment: "Button routing the user to more options"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(profileAction(_:)))

  private lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
  private lazy var postButton = UIBarButtonItem(title: NSLocalizedString("Post", comment: "Button prompting the user to create a dropp"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(postAction(_:)))

  // MARK: - Public

  /// Default is `false`
  var didPresentViewController: Bool = false
  // swiftlint:disable:next implicitly_unwrapped_optional
  var currentUserViewModel: CurrentUserViewModelProtocol! {
    didSet {
      // Pass on value derived in subclass
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

private extension CurrentUserViewController {
  func deleteRows(at indexPaths: [IndexPath], refreshUserInfo: Bool = true) {
    tableView.performBatchUpdates({ [weak self] in
      self?.tableView.deleteRows(at: indexPaths, with: .automatic)
      if refreshUserInfo {
        self?.tableView.reloadRows(at: [Constants.Table.userIndexPath], with: .automatic)
      }
      }, completion: nil)
  }

  func finishEditing() {
    currentUserViewModel.finishEditing()
    setEditing(false, animated: true)
    tableView.insertRows(at: [Constants.Table.userIndexPath], with: .top)
  }
}

// MARK: - Actions

private extension CurrentUserViewController {
  @objc
  func editAction(_ sender: UIBarButtonItem) {
    setEditing(true, animated: true)
    tableView.deleteRows(at: [Constants.Table.userIndexPath], with: .top)
  }

  @objc
  func cancelAction(_ sender: UIBarButtonItem) {
    finishEditing()
  }

  @objc
  func deleteAction(_ sender: UIBarButtonItem) {
    currentUserViewModel.deleteSelectedDropps { rows in
      let indexPaths = rows.map { IndexPath(row: $0, section: Constants.Table.droppsSection) }
      deleteRows(at: indexPaths, refreshUserInfo: false)
    }

    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    finishEditing()
    generator.notificationOccurred(.success)
  }

  @objc
  func logOutAction(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: NSLocalizedString("Log out?", comment: "Question confirming the user wants to log out"),
                                            message: nil,
                                            preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Button canceling the log out action"),
                                            style: .cancel,
                                            handler: nil))
    // swiftlint:disable:next trailing_closure
    alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Button confirming the log out action"),
                                            style: .destructive,
                                            handler: { [weak self] _ in
                                              guard let self = self else { return }
                                              self.currentUserViewModel.shouldLogOut()
                                              if self.didPresentViewController {
                                                self.dismiss(animated: true, completion: nil)
                                              }
    }))

    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    alertController.present(from: self, barButtonItem: sender, sourceView: nil, animated: true, completion: nil)
    generator.notificationOccurred(.warning)
  }

  @objc
  func profileAction(_ sender: UIBarButtonItem) {
  }

  @objc
  func doneAction(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  // TODO: Remove
  @objc
  func postAction(_ sender: UIBarButtonItem) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    MainDroppProvider().addDroppForCurrentUser()
    generator.notificationOccurred(.success)
  }
}

// MARK: - UITableViewDataSource

extension CurrentUserViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rows: Int
    switch section {
    case 0:
      rows = isEditing ? 0 : super.tableView(tableView, numberOfRowsInSection: section)
    case 1:
      rows = super.tableView(tableView, numberOfRowsInSection: section)
    default:
      fatalError("Encountered unexpected section: \(section)")
    }
    return rows
  }
}

// MARK: - UITableViewDelegate

extension CurrentUserViewController {
  func tableView(_ tableView: UITableView,
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if isEditing { return nil }
    let deleteUpdates: () -> Void = { [weak self] in
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      self?.deleteRows(at: [indexPath])
      generator.notificationOccurred(.success)
    }
    let deleteAction = UIContextualAction(style: .destructive,
                                          title: NSLocalizedString("Delete", comment: "Button prompting the user to delete the item")) { [weak self] _, _, _ in
                                            // swiftlint:disable:previous line_length
                                            self?.currentUserViewModel.deleteDropp(atIndex: indexPath.row, performUpdates: deleteUpdates)
    }
    deleteAction.backgroundColor = .buttonBackground
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { indexPath.section > 0 }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isEditing {
      currentUserViewModel.add(deletedRow: indexPath.row)
    } else {
      super.tableView(tableView, didSelectRowAt: indexPath)
    }
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if isEditing {
      currentUserViewModel.remove(deletedRow: indexPath.row)
    }
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
