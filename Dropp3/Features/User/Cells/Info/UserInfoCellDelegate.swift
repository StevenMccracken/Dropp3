//
//  UserInfoCellDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//

import Foundation

protocol UserInfoCellDelegate: AnyObject {
  func userInfoTableViewCell(shouldShowDroppsFromCell userInfoTableViewCell: UserInfoTableViewCell)
  func userInfoTableViewCell(shouldShowFollowersFromCell userInfoTableViewCell: UserInfoTableViewCell)
  func userInfoTableViewCell(shouldShowFollowingFromCell userInfoTableViewCell: UserInfoTableViewCell)
}
