//
//  LogInViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

class LogInViewController: UITableViewController, WelcomeViewPage, RealmProviderConsumer {
  var delegate: WelcomeViewDelegate?
  private var textFields: [UITextField] = []
  private var textFieldValidations: [UITextField: UInt] = [:]

  // MARK: - Outlets

  @IBOutlet weak var logInButton: UIButton!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  private var username: String {
    return usernameTextField.text!
  }
}

// MARK: - View lifecycle

extension LogInViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Log In"
    textFieldValidations = [
      usernameTextField: 8,
      passwordTextField: 10
    ]
    textFields = [usernameTextField, passwordTextField]
  }
}

// MARK: - Actions

extension LogInViewController {
  @IBAction private func logInAction(_ sender: Any) {
    logInButton.isEnabled = false
    delegate?.welcomeViewChild(self, didToggleLoading: true)
    let user = CurrentUser(username: username, firstName: UUID().uuidString, lastName: UUID().uuidString)
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
      self?.realmProvider.add(user)
      let normalUser = user.copy() as! User
      self?.realmProvider.add(normalUser)
    }
  }

  @IBAction func textFieldDidChange(_ sender: UITextField) {
    let validations: [Bool] = textFieldValidations.map { (textField, requiredCharacters) in
      let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      let matchesValidation = trimmedText.count >= requiredCharacters
      textField.textColor = matchesValidation ? .black : .disabled
      return matchesValidation
    }

    let validTextFields = validations.filter { $0 }
    logInButton.isEnabled = validTextFields.count == textFieldValidations.count
  }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
