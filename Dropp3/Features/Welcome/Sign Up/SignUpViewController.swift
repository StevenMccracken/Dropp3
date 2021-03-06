//
//  SignUpViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//

import UIKit

final class SignUpViewController: UITableViewController, WelcomeViewPage {
  weak var delegate: WelcomeViewDelegate?
  private lazy var viewModel: SignUpViewModelProtocol = {
    var viewModel = container.resolve(SignUpViewModelProtocol.self)!
    viewModel.delegate = self
    return viewModel
  }()

  // MARK: - Subviews

  @IBOutlet private weak var signUpButton: UIButton!
  @IBOutlet private weak var usernameTextField: UITextField!
  @IBOutlet private weak var firstNameTextField: UITextField!
  @IBOutlet private weak var lastNameTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var confirmPasswordTextField: UITextField!
}

// MARK: - View lifecycle

extension SignUpViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = NSLocalizedString("Sign Up", comment: "Title telling the user to sign up for the app")
  }
}

// MARK: - Editing

extension SignUpViewController {
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if !editing {
      [usernameTextField, firstNameTextField, lastNameTextField, passwordTextField, confirmPasswordTextField].forEach {
        $0?.resignFirstResponder()
      }
    }
  }
}

// MARK: - Actions

private extension SignUpViewController {
  @IBAction func signUpAction(_ sender: UIButton) {
    viewModel.attemptSignUp()
  }

  @IBAction func textFieldDidChange(_ sender: UITextField) {
    switch sender {
    case firstNameTextField:
      viewModel.process(firstName: sender.text ?? "")
    case lastNameTextField:
      viewModel.process(lastName: sender.text ?? "")
    case usernameTextField:
      viewModel.process(username: sender.text ?? "")
    case passwordTextField:
      viewModel.process(password: sender.text ?? "")
    case confirmPasswordTextField:
      viewModel.process(confirmedPassword: sender.text ?? "")
    default:
      fatalError("Unrecognized text field")
    }
  }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    string.rangeOfCharacter(from: .whitespaces) == nil
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case firstNameTextField:
      lastNameTextField.becomeFirstResponder()
    case lastNameTextField:
      usernameTextField.becomeFirstResponder()
    case usernameTextField:
      passwordTextField.becomeFirstResponder()
    case passwordTextField:
      confirmPasswordTextField.becomeFirstResponder()
    case confirmPasswordTextField:
      textField.resignFirstResponder()
    default:
      fatalError("Unrecognized text field")
    }
    return true
  }
}

// MARK: - SignUpViewModelDelegate

extension SignUpViewController: SignUpViewModelDelegate {
  func toggleLoading(_ loading: Bool) {
    delegate?.welcomeViewPage(self, didToggleLoading: loading)
  }

  func toggleSignUpAction(enabled: Bool) {
    signUpButton.isEnabled = enabled
  }

  func toggleFirstNameField(valid: Bool) {
    firstNameTextField.textColor = valid ? .black : .disabled
  }

  func toggleLastNameField(valid: Bool) {
    lastNameTextField.textColor = valid ? .black : .disabled
  }

  func toggleUsernameField(valid: Bool) {
    usernameTextField.textColor = valid ? .black : .disabled
  }

  func togglePasswordField(valid: Bool) {
    passwordTextField.textColor = valid ? .black : .disabled
  }

  func toggleConfirmedPasswordField(valid: Bool) {
    confirmPasswordTextField.textColor = valid ? .black : .disabled
  }

  func signUpDidSucceed() {
    debugPrint("Sign up succeeded!")
  }

  func signUpDidFail(reason: String) {
    debugPrint(reason)
  }
}
