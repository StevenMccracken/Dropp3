//
//  AppearanceManager.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

final class AppearanceManager: NSObject {
  override init() {
    super.init()
    customizeAppearances()
  }
}

// MARK: - Styling

private extension AppearanceManager {
  func customizeAppearances() {
    customizeButtons()
    customizeBarButtonItems()
  }

  func customizeButtons() {
    let appearance = UIButton.appearance()
    appearance.tintColor = .primary
    appearance.setTitleColor(.primary, for: .normal)
    appearance.setTitleColor(.primaryLight, for: .highlighted)
    appearance.setTitleColor(UIColor.primary.withAlphaComponent(0.5), for: .disabled)
  }

  func customizeBarButtonItems() {
    let appearance = UIBarButtonItem.appearance()
    appearance.tintColor = .primary
  }
}

