//
//  UserViewModelDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserViewModelDelegate: AnyObject {
  func exitView()
  func reloadData()
  func updateUserData()
  func updateData(deletions: [Int], insertions: [Int], modifications: [Int])
}
