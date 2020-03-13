//
//  AppearanceManager.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//

import UIKit

/// Main implementation of `AppearanceManaging`
struct AppearanceManager {
  // MARK: - Styling

  private func customizeButtons() {
    let appearance = UIButton.appearance()
    appearance.tintColor = .primary
    appearance.setTitleColor(.primary, for: .normal)
    appearance.setTitleColor(.primaryLight, for: .highlighted)
    appearance.setTitleColor(UIColor.primary.withAlphaComponent(0.5), for: .disabled)
  }

  private func customizeBarButtonItems() {
    let appearance = UIBarButtonItem.appearance()
    appearance.tintColor = .primary
  }
}

// MARK: - AppearanceManaging

extension AppearanceManager: AppearanceManaging {
  func customizeAppearances() {
    customizeButtons()
    customizeBarButtonItems()
  }
}
