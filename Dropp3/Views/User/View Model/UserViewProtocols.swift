//
//  UserViewProtocols.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserViewModelDelegate: AnyObject {
  func exitView()
  func reloadData()
  func updateUserData()
  func updateData(deletions: [Int], insertions: [Int], modifications: [Int])
}

protocol UserViewModelProtocol {
  var user: User { get }
  var title: String { get }
  var delegate: UserViewModelDelegate? { get set }

  var sections: Int { get }
  func numberOfRows(forSection section: Int) -> Int

  func viewDidLoad()
  func shouldRefreshData()
  func didRefreshData()
}
