//
//  UserDroppCellDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/4/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserDroppCellDelegate: AnyObject {
  func userDroppTableViewCell(shouldShowLocationFromCell userDroppTableViewCell: UserDroppTableViewCell)
}
