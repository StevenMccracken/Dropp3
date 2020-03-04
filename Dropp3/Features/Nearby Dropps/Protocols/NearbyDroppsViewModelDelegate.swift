//
//  NearbyDroppsViewModelDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//

import Foundation

protocol NearbyDroppsViewModelDelegate: AnyObject {
  func reloadData()
  func updateData(deletions: [Int], insertions: [Int], modifications: [Int])
}
