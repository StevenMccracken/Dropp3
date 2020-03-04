//
//  SignUpViewModelDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/1/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

protocol SignUpViewModelDelegate: AnyObject {
  // MARK: - Control toggling

  func toggleLoading(_ loading: Bool)
  func toggleSignUpAction(enabled: Bool)
  func toggleFirstNameField(valid: Bool)
  func toggleLastNameField(valid: Bool)
  func toggleUsernameField(valid: Bool)
  func togglePasswordField(valid: Bool)
  func toggleConfirmedPasswordField(valid: Bool)

  // MARK: - Sign up handlers

  func signUpDidSucceed()
  func signUpDidFail(reason: String)
}
