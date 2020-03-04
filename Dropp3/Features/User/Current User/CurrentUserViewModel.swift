//
//  CurrentUserViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

final class CurrentUserViewModel: UserViewModel, RealmProviderConsumer, DroppProviderConsumer {
  // MARK: - Public

  weak var currentUserViewDelegate: CurrentUserViewDelegate?

  // MARK: - Private

  private lazy var selectedRowsForDeletion: Set<Int> = []

  // MARK: - Overrides

  override func didRefreshData() {
    super.didRefreshData()
    currentUserViewDelegate?.toggleEditButton(enabled: !user.dropps.isEmpty)
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
    observationTokens.forEach { $0.invalidate() }
    guard let currentUser = self.currentUser else {
      debugPrint("Unable to perform log out because current user could not be resolved")
      return
    }
    realmProvider.delete(currentUser)
  }

  func deleteSelectedDropps(performUpdates: ([Int]) -> Void) {
    let dropps = selectedRowsForDeletion.map { user.dropps[$0] }
    let transaction: () -> Void = {
      dropps.forEach { dropp in
        guard let index = self.user.dropps.firstIndex(of: dropp) else {
          debugPrint("Unable to find selected dropp in current user's dropps")
          return
        }
        self.user.dropps.remove(at: index)
      }

      performUpdates(Array(self.selectedRowsForDeletion))
    }

    realmProvider.transaction(withoutNotifying: Array(observationTokens), transaction: transaction)
    realmProvider.delete(dropps)
    didRefreshData()
  }

  func deleteDropp(atIndex index: Int, performUpdates: () -> Void) {
    let dropp = user.dropps[index]
    realmProvider.transaction(withoutNotifying: Array(observationTokens)) {
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

// MARK: - Validation

private extension CurrentUserViewModel {
  func validateDeletionState() {
    currentUserViewDelegate?.toggleDeleteButton(enabled: !selectedRowsForDeletion.isEmpty)
  }
}
