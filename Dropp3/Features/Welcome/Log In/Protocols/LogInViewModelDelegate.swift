//
//  LogInViewModelDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/22/20.
//

import Foundation

protocol LogInViewModelDelegate: AnyObject {
  // MARK: - Control toggling

  func toggleLoading(_ loading: Bool)
  func toggleLoginAction(enabled: Bool)
  func toggleUsernameField(valid: Bool)
  func togglePasswordField(valid: Bool)

  // MARK: - Login handlers

  func loginDidSucceed()
  func loginDidFail(reason: String)
}
