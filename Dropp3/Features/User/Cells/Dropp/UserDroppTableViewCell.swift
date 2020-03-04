//
//  UserDroppTableViewCell.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/27/19.
//

import UIKit

final class UserDroppTableViewCell: UITableViewCell {
  static let nib = UINib(nibName: "UserDroppTableViewCell", bundle: .main)
  weak var delegate: UserDroppCellDelegate?

  // MARK: - Subviews

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

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    locationButton.isEnabled = !editing
  }
}

// MARK: - Data providing

extension UserDroppTableViewCell {
  func provide(dropp: Dropp) {
    messageLabel.text = dropp.message
    guard let location = dropp.location else {
      debugPrint("Unable to display location in cell for given dropp")
      return
    }
    locationButton.setTitle("\(location.latitude), \(location.longitude)", for: .normal)
  }
}

// MARK: - Actions

private extension UserDroppTableViewCell {
  @IBAction func locationButtonAction(_ sender: UIButton) {
    delegate?.userDroppTableViewCell(shouldShowLocationFromCell: self)
  }
}
