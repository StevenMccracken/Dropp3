//
//  CurrentUserViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol CurrentUserViewDelegate: AnyObject {
  func toggleEditButton(enabled: Bool)
  func toggleDeleteButton(enabled: Bool)
}

protocol CurrentUserViewModelProtocol: UserViewModelProtocol {
  var currentUserViewDelegate: CurrentUserViewDelegate? { get set }

  func shouldLogOut()
  func add(deletedRow: Int)
  func remove(deletedRow: Int)

  func finishEditing()
  func deleteSelectedDropps(performUpdates: ([Int]) -> Void)
  func deleteDropp(atIndex index: Int, performUpdates: () -> Void)
}

class CurrentUserViewModel: UserViewModel, RealmProviderConsumer, DroppProviderConsumer {
  private lazy var selectedRowsForDeletion: Set<Int> = []
  weak var currentUserViewDelegate: CurrentUserViewDelegate?

  override func didRefreshData() {
    super.didRefreshData()
    currentUserViewDelegate?.toggleEditButton(enabled: !user.dropps.isEmpty)
  }

  private func validateDeletionState() {
    currentUserViewDelegate?.toggleDeleteButton(enabled: !selectedRowsForDeletion.isEmpty)
  }
}

// MARK: - CurrentUserViewModelProtocol

extension CurrentUserViewModel: CurrentUserViewModelProtocol {
  func add(deletedRow: Int) {
    selectedRowsForDeletion.insert(deletedRow)
    validateDeletionState()
  }

  func remove(deletedRow: Int) {
    selectedRowsForDeletion.remove(deletedRow)
    validateDeletionState()
  }

  func shouldLogOut() {
    tokens.forEach { $0.invalidate() }
    guard let currentUser = self.currentUser else { fatalError() }
    realmProvider.delete(currentUser)
  }

  func deleteSelectedDropps(performUpdates: ([Int]) -> Void) {
    let dropps = selectedRowsForDeletion.map { user.dropps[$0] }
    realmProvider.transaction(withoutNotifying: Array(tokens)) {
      dropps.forEach { dropp in
        guard let index = user.dropps.firstIndex(of: dropp) else { fatalError() }
        user.dropps.remove(at: index)
      }

      performUpdates(Array(selectedRowsForDeletion))
    }

    realmProvider.delete(dropps)
    didRefreshData()
  }

  func deleteDropp(atIndex index: Int, performUpdates: () -> Void) {
    let dropp = user.dropps[index]
    realmProvider.transaction(withoutNotifying: Array(tokens)) {
      user.dropps.remove(at: index)
      performUpdates()
    }

    realmProvider.delete(dropp)
    didRefreshData()
  }

  func finishEditing() {
    selectedRowsForDeletion.removeAll()
  }
}
