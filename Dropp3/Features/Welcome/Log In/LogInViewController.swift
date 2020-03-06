//
//  LogInViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//

import UIKit

final class LogInViewController: UITableViewController, WelcomeViewPage, ContainerConsumer {
  weak var delegate: WelcomeViewDelegate?
  private lazy var viewModel: LogInViewModelProtocol = {
    var viewModel = container.resolve(LogInViewModelProtocol.self)!
    viewModel.delegate = self
    return viewModel
  }()

  // MARK: - Subviews

  @IBOutlet private weak var logInButton: UIButton!
  @IBOutlet private weak var usernameTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
}

// MARK: - View lifecycle

extension LogInViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = NSLocalizedString("Log In", comment: "Title telling the user to log in to the app")
  }
}

// MARK: - Editing

extension LogInViewController {
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    if !editing {
      [usernameTextField, passwordTextField].forEach { $0?.resignFirstResponder() }
    }
  }
}

// MARK: - Actions

private extension LogInViewController {
  @IBAction func logInAction(_ sender: UIButton) {
    viewModel.attemptLogin()
  }

  @IBAction func textFieldDidChange(_ sender: UITextField) {
    switch sender {
    case usernameTextField:
      viewModel.process(username: sender.text ?? "")
    case passwordTextField:
      viewModel.process(password: sender.text ?? "")
    default:
      fatalError("Unrecognized text field")
    }
  }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    string.rangeOfCharacter(from: .whitespaces) == nil
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case usernameTextField:
      passwordTextField.becomeFirstResponder()
    case passwordTextField:
      textField.resignFirstResponder()
    default:
      fatalError("Unrecognized text field")
    }
    return true
  }
}

// MARK: - LogInViewModelDelegate

extension LogInViewController: LogInViewModelDelegate {
  func toggleLoading(_ loading: Bool) {
    delegate?.welcomeViewPage(self, didToggleLoading: loading)
  }

  func toggleLoginAction(enabled: Bool) {
    logInButton.isEnabled = enabled
  }

  func toggleUsernameField(valid: Bool) {
    usernameTextField.textColor = valid ? .black : .disabled
  }

  func togglePasswordField(valid: Bool) {
    passwordTextField.textColor = valid ? .black : .disabled
  }

  func loginDidSucceed() {
    debugPrint("Success!")
  }

  func loginDidFail(reason: String) {
    debugPrint(reason)
  }
}
