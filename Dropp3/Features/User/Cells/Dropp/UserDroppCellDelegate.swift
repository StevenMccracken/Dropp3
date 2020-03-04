//
//  UserDroppCellDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//

import Foundation

protocol UserDroppCellDelegate: AnyObject {
  func userDroppTableViewCell(shouldShowLocationFromCell userDroppTableViewCell: UserDroppTableViewCell)
}
