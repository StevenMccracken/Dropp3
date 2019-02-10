//
//  UITableView+Data.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func update(section: Int = 0, deletions: [Int], insertions: [Int], modifications: [Int]) {
    performBatchUpdates({
      [(insertRows, insertions, section),
       (deleteRows, deletions, section),
       (reloadRows, modifications, section)].forEach(perform)
    })
  }

  private func perform(update: ([IndexPath], UITableView.RowAnimation) -> Void, forIndexes indexes: [Int], in section: Int) {
    if indexes.isEmpty { return }
    let indexPaths = indexes.map { IndexPath(row: $0, section: section) }
    update(indexPaths, .automatic)
  }
}
