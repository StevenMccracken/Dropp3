//
//  Colors.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//

import Foundation
import UIKit

extension UIColor {
  static let primary = UIColor(named: "Primary")!
  static let primaryDark = UIColor(named: "PrimaryDark")!
  static let primaryLight = UIColor(named: "PrimaryLight")!
  static let disabled = UIColor { $0.userInterfaceStyle == .light ? .primaryDark : .primaryLight }
  static let buttonBackground = UIColor.lightGray.withAlphaComponent(0.1)
}
