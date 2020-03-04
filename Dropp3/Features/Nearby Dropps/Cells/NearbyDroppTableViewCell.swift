//
//  NearbyDroppTableViewCell.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/20/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

final class NearbyDroppTableViewCell: UITableViewCell, UserProviderConsumer {
  static let nib = UINib(nibName: "NearbyDroppTableViewCell", bundle: .main)
  weak var delegate: NearbyDroppCellDelegate?

  // MARK: - Subviews

  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var locationLabel: UILabel!
  @IBOutlet private weak var usernameButton: UIButton!
}

// MARK: - View configuration

extension NearbyDroppTableViewCell {
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
    let user = userProvider.user(for: dropp.userID!)
    usernameButton.setTitle(user?.username, for: .normal)
    guard let location = dropp.location else {
      debugPrint("Unable to display location in cell for given dropp")
      return
    }
    locationLabel.text = "\(location.latitude), \(location.longitude)"
  }
}

// MARK: - Actions

private extension NearbyDroppTableViewCell {
  @IBAction func userButtonAction(_ sender: UIButton) {
    delegate?.nearbyDroppTableViewCell(shouldShowUserFromCell: self)
  }
}
