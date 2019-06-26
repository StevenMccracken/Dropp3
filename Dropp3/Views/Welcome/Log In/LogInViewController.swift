//
//  LogInViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class LogInViewController: UITableViewController, WelcomeViewPage {
  var viewModel: LogInViewModel! = LogInViewModel()
  var delegate: WelcomeViewDelegate?

  private var textFields: [UITextField]!
  private var logInAction: CocoaAction<Any>!

  // MARK: - Outlets

  @IBOutlet weak var logInButton: UIButton!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
}

// MARK: - View lifecycle

extension LogInViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Log In"
    logInButton.reactive.isEnabled <~ viewModel.logInEnabled.producer
    viewModel.username <~ usernameTextField.reactive.continuousTextValues.producer
    viewModel.password <~ passwordTextField.reactive.continuousTextValues.producer
    logInAction = CocoaAction(viewModel.logInAction, input: ())
    logInButton.addTarget(logInAction, action: CocoaAction<Any>.selector, for: .touchUpInside)
    logInButton.reactive.controlEvents(.touchUpInside).observeValues { [unowned self] _ in
      self.delegate?.welcomeViewChild(self, didToggleLoading: true)
    }

    viewModel.logInSignal.observeResult { result in
      guard let success = result.value else { return }
      print(success)
    }

    viewModel.logInSignal.observeFailed { error in
      print(error.localizedDescription)
    }

    textFields = [usernameTextField, passwordTextField]
  }
}

// MARK: - Actions

extension LogInViewController {
  @IBAction private func logInAction(_ sender: Any) {
//    logInButton.isEnabled = false
//    currentUserService = userService
//    currentUserService?.logIn(username: username, password: UUID().uuidString, success: nil) { [weak self] error in
//      self?.currentUserService = nil
//      print(error)
//    }
  }

  @IBAction func textFieldDidChange(_ sender: UITextField) {
//    let validations: [Bool] = textFieldValidations.map { (textField, requiredCharacters) in
//      let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//      let matchesValidation = trimmedText.count >= requiredCharacters
//      textField.textColor = matchesValidation ? .black : .disabled
//      return matchesValidation
//    }
//
//    let validTextFields = validations.filter { $0 }
//    logInButton.isEnabled = validTextFields.count == textFieldValidations.count
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
