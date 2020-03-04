//
//  CurrentUserViewModelProtocol.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//

import Foundation

protocol CurrentUserViewModelProtocol: UserViewModelProtocol {
  var currentUserViewDelegate: CurrentUserViewDelegate? { get set }

  func shouldLogOut()
  func add(deletedRow: Int)
  func remove(deletedRow: Int)

  func finishEditing()
  func deleteSelectedDropps(performUpdates: ([Int]) -> Void)
  func deleteDropp(atIndex index: Int, performUpdates: () -> Void)
}
