//
//  NearbyDroppCellDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//

import Foundation

protocol NearbyDroppCellDelegate: AnyObject {
  func nearbyDroppTableViewCell(shouldShowUserFromCell nearbyDroppTableViewCell: NearbyDroppTableViewCell)
}
