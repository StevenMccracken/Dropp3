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

class NearbyDroppTableViewCell: UITableViewCell {
  static let nib = UINib(nibName: "NearbyDroppTableViewCell", bundle: .main)

  weak var delegate: NearbyDroppCellDelegate?

  // MARK: - Outlets

  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var locationLabel: UILabel!
  @IBOutlet private weak var usernameButton: UIButton!
  @IBOutlet private weak var locationRegularHeightConstraint: NSLayoutConstraint!
  private var originalLocationHeight: CGFloat!

  // MARK: - View configuration

  private var hidesContent: Bool = false {
    didSet {
      locationRegularHeightConstraint.constant = hidesContent ? Constants.hiddenHeight : originalLocationHeight
      [usernameButton, messageLabel].forEach { $0?.isHidden = hidesContent }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    originalLocationHeight = locationRegularHeightConstraint.constant
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    usernameButton.setTitle(nil, for: .normal)
    [messageLabel, locationLabel].forEach { $0.text = nil }
    hidesContent = false
  }
}

// MARK: - Data providing

extension NearbyDroppTableViewCell {
  func provide(dropp: Dropp) {
    messageLabel.text = dropp.message
    usernameButton.setTitle(dropp.user?.username, for: .normal)
    guard let location = dropp.location else { fatalError() }
    locationLabel.text = "\(location.latitude), \(location.longitude)"
    hidesContent = dropp.hidden
  }
}

// MARK: - Actions

extension NearbyDroppTableViewCell {
  @IBAction private func userButtonAction(_ sender: UIButton) {
    delegate?.nearbyDroppTableViewCell(shouldShowUserFromCell: self)
  }
}
