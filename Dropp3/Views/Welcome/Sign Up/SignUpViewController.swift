//
//  SignUpViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController, WelcomeViewPage {
  var delegate: WelcomeViewDelegate?
  private var currentUserService: UserService?
  private var textFields: [UITextField] = []
  private var nonWhitespaceTextFields: Set<UITextField> = []
  private var textFieldValidations: [UITextField: UInt] = [:]

  // MARK: - Outlets

  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!

  private var username: String {
    return usernameTextField.text!
  }

  private var password: String {
    return passwordTextField.text!
  }

  private var firstName: String {
    return firstNameTextField.text!
  }

  private var lastName: String {
    return lastNameTextField.text!
  }
}

// MARK: - View lifecycle

extension SignUpViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Sign Up", comment: "Title telling the user to sign up for the app")
    textFieldValidations = [
      usernameTextField: 8,
      firstNameTextField: 2,
      lastNameTextField: 2,
      passwordTextField: 10,
      confirmPasswordTextField: 10
    ]
    textFields = [usernameTextField, firstNameTextField, lastNameTextField, passwordTextField, confirmPasswordTextField]
    [usernameTextField, passwordTextField, confirmPasswordTextField].forEach {
      nonWhitespaceTextFields.insert($0)
    }
  }
}

// MARK: - Actions

extension SignUpViewController {
  @IBAction private func signUpAction(_ sender: Any) {
    signUpButton.isEnabled = false
    delegate?.welcomeViewChild(self, didToggleLoading: true)
    currentUserService = userService
    currentUserService?.signUp(username: username,
                               password: password,
                               firstName: firstName,
                               lastName: lastName,
                               success: nil) { [weak self] error in
                                self?.currentUserService = nil
                                print(error)
    }
  }

  @IBAction func textFieldDidChange(_ sender: UITextField) {
    let validations: [Bool] = textFieldValidations.map { (textField, requiredCharacters) in
      let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      let matchesValidation = trimmedText.count >= requiredCharacters
      let matchesExtraValidation: Bool
      defer {
        textField.textColor = matchesValidation && matchesExtraValidation ? .black : .disabled
      }

      guard textField == passwordTextField || textField == confirmPasswordTextField else {
        matchesExtraValidation = true
        return matchesValidation
      }

      matchesExtraValidation = passwordTextField.text == confirmPasswordTextField.text
      return matchesValidation && matchesExtraValidation
    }

    let validTextFields = validations.filter { $0 }
    signUpButton.isEnabled = validTextFields.count == textFields.count
  }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    guard nonWhitespaceTextFields.contains(textField) else { return true }
    return string.rangeOfCharacter(from: .whitespaces) == nil
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFields.last {
      textField.resignFirstResponder()
    } else {
      guard let index = textFields.firstIndex(of: textField) else { fatalError() }
      textFields[index + 1].becomeFirstResponder()
    }

    return true
  }
}
