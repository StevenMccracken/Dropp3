//
//  UITableView+Data.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//

import Foundation
import UIKit

extension UITableView {
  /**
   Performs batch updates to the given section for given row deletions, insertions, and modifications
   - parameter section: the section to update. Default is `0`
   - parameter deletions: the deletions to update with
   - parameter insertions: the insertions to update with
   - parameter modifications: the modifications to update with
   - note: Updates will only take effect if the given list is not empty
   */
  func update(section: Int = 0, deletions: [Int], insertions: [Int], modifications: [Int]) {
    performBatchUpdates({
      [(insertRows, insertions, section),
       (deleteRows, deletions, section),
       (reloadRows, modifications, section)].forEach(perform)
    })
  }

  /**
   Performs a table view update function for given rows in a section
   - parameter update: the table view update function
   - parameter indexes: the rows to update. Returns immediately if empty
   - parameter section: the section to update
   - note: uses `automatic` animation
   */
  private func perform(update: ([IndexPath], UITableView.RowAnimation) -> Void, forIndexes indexes: [Int], in section: Int) {
    if indexes.isEmpty { return }
    let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
    update(indexPaths, .automatic)
  }
}
