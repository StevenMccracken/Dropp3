//
//  NearbyDroppTableViewCell.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/20/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

private struct Constants {
  static let hiddenHeight: CGFloat = 45
}

protocol NearbyDroppCellDelegate: AnyObject {
  func nearbyDroppTableViewCell(shouldShowUserFromCell nearbyDroppTableViewCell: NearbyDroppTableViewCell)
}

class NearbyDroppTableViewCell: UITableViewCell, RealmProviderConsumer {
  static let nib = UINib(nibName: "NearbyDroppTableViewCell", bundle: .main)

  weak var delegate: NearbyDroppCellDelegate?

  // MARK: - Outlets

  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var locationLabel: UILabel!
  @IBOutlet private weak var usernameButton: UIButton!

  // MARK: - View configuration

  override func prepareForReuse() {
    super.prepareForReuse()
    usernameButton.setTitle(nil, for: .normal)
    [messageLabel, locationLabel].forEach { $0.text = nil }
  }
}

// MARK: - Data providing

extension NearbyDroppTableViewCell {
  func provide(dropp: Dropp) {
    messageLabel.text = dropp.message
    let user = realmProvider.object(User.self, key: dropp.userID!)
    usernameButton.setTitle(user?.username, for: .normal)
    guard let location = dropp.location else { fatalError() }
    locationLabel.text = "\(location.latitude), \(location.longitude)"
  }
}

// MARK: - Actions

extension NearbyDroppTableViewCell {
  @IBAction private func userButtonAction(_ sender: UIButton) {
    delegate?.nearbyDroppTableViewCell(shouldShowUserFromCell: self)
  }
}
