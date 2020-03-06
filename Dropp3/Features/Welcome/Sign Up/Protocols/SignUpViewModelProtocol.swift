//
//  SignUpViewModelProtocol.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/1/20.
//

import Foundation

protocol SignUpViewModelProtocol: UserServiceConsumer {
  var delegate: SignUpViewModelDelegate? { get set }

  func process(firstName: String)
  func process(lastName: String)
  func process(username: String)
  func process(password: String?)
  func process(confirmedPassword: String?)
  func attemptSignUp()
}
