//
//  UserInfoTableViewCell.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/28/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

protocol UserInfoCellDelegate: AnyObject {
  func userInfoTableViewCell(shouldShowDroppsFromCell userInfoTableViewCell: UserInfoTableViewCell)
  func userInfoTableViewCell(shouldShowFollowersFromCell userInfoTableViewCell: UserInfoTableViewCell)
  func userInfoTableViewCell(shouldShowFollowingFromCell userInfoTableViewCell: UserInfoTableViewCell)
}

class UserInfoTableViewCell: UITableViewCell {
  static let nib = UINib(nibName: "UserInfoTableViewCell", bundle: .main)

  weak var delegate: UserInfoCellDelegate?

  // MARK: - Outlets

  @IBOutlet private weak var fullNameLabel: UILabel!
  @IBOutlet private weak var droppsAmountButton: UIButton!
  @IBOutlet private weak var followersAmountButton: UIButton!
  @IBOutlet private weak var followingAmountButton: UIButton!
  @IBOutlet private weak var profileImageView: UIImageView!
}

// MARK: - View Configuration

extension UserInfoTableViewCell {
  override func prepareForReuse() {
    super.prepareForReuse()
    fullNameLabel.text = nil
    [droppsAmountButton, followersAmountButton, followingAmountButton].forEach { $0?.setTitle(nil, for: .normal) }
  }
}

// MARK: - Data providing

extension UserInfoTableViewCell {
  func provide(user: User) {
    fullNameLabel.text = user.fullName
    droppsAmountButton.setTitle("\(user.dropps.count)", for: .normal)
    followersAmountButton.setTitle("\(user.followers.count)", for: .normal)
    followingAmountButton.setTitle("\(user.following.count)", for: .normal)
  }
}

// MARK: - Actions

private extension UserInfoTableViewCell {
  @IBAction func followersButtonAction(_ sender: UIButton) {
    delegate?.userInfoTableViewCell(shouldShowFollowersFromCell: self)
  }

  @IBAction func followingButtonAction(_ sender: UIButton) {
    delegate?.userInfoTableViewCell(shouldShowFollowingFromCell: self)
  }

  @IBAction func droppsButtonAction(_ sender: UIButton) {
    delegate?.userInfoTableViewCell(shouldShowDroppsFromCell: self)
  }
}
