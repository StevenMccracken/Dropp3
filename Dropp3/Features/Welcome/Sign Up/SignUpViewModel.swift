//
//  SignUpViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/1/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

final class SignUpViewModel {
  private var firstName: String?
  private var lastName: String?
  private var username: String?
  private var password: String?
  private var confirmedPassword: String?
  weak var delegate: SignUpViewModelDelegate?
}

// MARK: - SignUpViewModelProtocol

extension SignUpViewModel: SignUpViewModelProtocol {
  func process(firstName: String) {
    self.firstName = firstName
    validateNameField(name: firstName, toggleAction: delegate?.toggleFirstNameField(valid:))
    validateSignUpAction()
  }

  func process(lastName: String) {
    self.lastName = lastName
    validateNameField(name: lastName, toggleAction: delegate?.toggleLastNameField(valid:))
    validateSignUpAction()
  }

  func process(username: String) {
    self.username = username
    validateUsernameField(username: username)
    validateSignUpAction()
  }

  func process(password: String?) {
    self.password = password
    validatePasswordField(password: password)
    if let confirmedPassword = self.confirmedPassword {
      validateConfirmedPasswordField(confirmedPassword: confirmedPassword)
    }
    validateSignUpAction()
  }

  func process(confirmedPassword: String?) {
    self.confirmedPassword = confirmedPassword
    validateConfirmedPasswordField(confirmedPassword: confirmedPassword)
    validateSignUpAction()
  }

  func attemptSignUp() {
    guard let firstName = self.firstName,
      let lastName = self.lastName,
      let username = self.username,
      let password = self.password,
      let confirmedPassword = self.confirmedPassword,
      CredentialRules.Name(credential: firstName).isValid,
      CredentialRules.Name(credential: lastName).isValid,
      CredentialRules.Username(credential: username).isValid,
      CredentialRules.Password(credential: password).isValid,
      password == confirmedPassword else {
        return
    }

    delegate?.toggleLoading(true)
    delegate?.toggleSignUpAction(enabled: false)
    userService.signUp(username: username, password: password, firstName: firstName, lastName: lastName, success: { [weak self] in
      DispatchQueue.main.async {
        self?.delegate?.toggleLoading(false)
        self?.delegate?.signUpDidSucceed()
      }
    }) { [weak self] error in
      DispatchQueue.main.async {
        self?.delegate?.toggleLoading(false)
        self?.delegate?.toggleSignUpAction(enabled: true)
        self?.delegate?.signUpDidFail(reason: error.localizedDescription)
      }
    }
  }
}

// MARK: - Validations

private extension SignUpViewModel {
  func validateNameField(name: String, toggleAction: ((Bool) -> Void)?) {
    toggleAction?(CredentialRules.Name(credential: name).isValid)
  }
  func validateUsernameField(username: String) {
    delegate?.toggleUsernameField(valid: CredentialRules.Username(credential: username).isValid)
  }

  func validatePasswordField(password: String?) {
    delegate?.togglePasswordField(valid: CredentialRules.Password(credential: password ?? "").isValid)
  }

  func validateConfirmedPasswordField(confirmedPassword: String?) {
    guard let password = self.password, !password.isEmpty else {
      delegate?.toggleConfirmedPasswordField(valid: CredentialRules.Password(credential: confirmedPassword ?? "").isValid)
      return
    }
    delegate?.toggleConfirmedPasswordField(valid: CredentialRules.ConfirmPassword(credential: confirmedPassword ?? "",
                                                                                  dependentCredential: password).isValid)
  }

  func validateSignUpAction() {
    guard let firstName = self.firstName,
      let lastName = self.lastName,
      let username = self.username,
      let password = self.password,
      let confirmedPassword = self.confirmedPassword else {
        delegate?.toggleSignUpAction(enabled: false)
        return
    }
    let isValidFirstName = CredentialRules.Name(credential: firstName).isValid
    let isValidLastName = CredentialRules.Name(credential: lastName).isValid
    let isValidUsername = CredentialRules.Username(credential: username).isValid
    let isValidPassword = CredentialRules.Password(credential: password).isValid
    let isVaildConfirmedPassword = password == confirmedPassword
    delegate?.toggleSignUpAction(enabled: isValidFirstName
      && isValidLastName
      && isValidUsername
      && isValidPassword
      && isVaildConfirmedPassword)
  }
}
