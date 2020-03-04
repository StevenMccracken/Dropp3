//
//  LogInViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 5/25/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

final class LogInViewModel {
  private var username: String?
  private var password: String?
  weak var delegate: LogInViewModelDelegate?
}

// MARK: - LogInViewModelProtocol

extension LogInViewModel: LogInViewModelProtocol {
  func process(username: String) {
    self.username = username
    validateUsernameField(username: username)
    validateLoginAction()
  }

  func process(password: String) {
    self.password = password
    validatePasswordField(password: password)
    validateLoginAction()
  }

  func attemptLogin() {
    guard let username = self.username,
      let password = self.password,
      CredentialRules.Username(credential: username).isValid,
      CredentialRules.Password(credential: password).isValid else {
        return
    }
    delegate?.toggleLoading(true)
    delegate?.toggleLoginAction(enabled: false)
    userService.logIn(user: MainUserServiceUser(username: username, password: password), success: { [weak self] in
      DispatchQueue.main.async {
        self?.delegate?.toggleLoading(false)
        self?.delegate?.loginDidSucceed()
      }
    }) { [weak self] error in
      DispatchQueue.main.async {
        self?.delegate?.toggleLoading(false)
        self?.delegate?.toggleLoginAction(enabled: true)
        self?.delegate?.loginDidFail(reason: error.localizedDescription)
      }
    }
  }
}

// MARK: - Validations

private extension LogInViewModel {
  func validateUsernameField(username: String) {
    delegate?.toggleUsernameField(valid: CredentialRules.Username(credential: username).isValid)
  }

  func validatePasswordField(password: String) {
    delegate?.togglePasswordField(valid: CredentialRules.Password(credential: password).isValid)
  }

  func validateLoginAction() {
    guard let username = self.username, let password = self.password else {
      delegate?.toggleLoginAction(enabled: false)
      return
    }
    let isValidUsername = CredentialRules.Username(credential: username).isValid
    let isValidPassword = CredentialRules.Password(credential: password).isValid
    delegate?.toggleLoginAction(enabled: isValidUsername && isValidPassword)
  }
}
