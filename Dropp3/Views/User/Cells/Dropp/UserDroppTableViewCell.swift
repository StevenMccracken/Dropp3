//
//  UserDroppTableViewCell.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/27/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

protocol UserDroppCellDelegate: AnyObject {
  func userDroppTableViewCell(shouldShowLocationFromCell userDroppTableViewCell: UserDroppTableViewCell)
}

class UserDroppTableViewCell: UITableViewCell {
  static let nib = UINib(nibName: "UserDroppTableViewCell", bundle: .main)

  weak var delegate: UserDroppCellDelegate?

  // MARK: - Outlets

  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var locationButton: UIButton!
}

// MARK: - View Configuration

extension UserDroppTableViewCell {
  override func prepareForReuse() {
    super.prepareForReuse()
    messageLabel.text = nil
    locationButton.setTitle(nil, for: .normal)
  }
}

// MARK: - Data providing

extension UserDroppTableViewCell {
  func provide(dropp: Dropp) {
    messageLabel.text = dropp.message
    guard let location = dropp.location else {
      fatalError()
    }

    locationButton.setTitle("\(location.latitude), \(location.longitude)", for: .normal)
  }
}

// MARK: - Actions

extension UserDroppTableViewCell {
  @IBAction private func locationButtonAction(_ sender: UIButton) {
    delegate?.userDroppTableViewCell(shouldShowLocationFromCell: self)
  }
}
