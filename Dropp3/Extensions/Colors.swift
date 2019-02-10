//
//  Colors.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  static let primary = UIColor(named: "Primary")!
  static let primaryDark = UIColor(named: "PrimaryDark")!
  static let primaryLight = UIColor(named: "PrimaryLight")!
  static let disabled = UIColor.primaryDark
  static let buttonBackground = UIColor.lightGray.withAlphaComponent(0.1)
}
