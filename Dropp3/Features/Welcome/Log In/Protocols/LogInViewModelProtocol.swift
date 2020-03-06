//
//  LogInViewModelProtocol.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/22/20.
//

import Foundation

protocol LogInViewModelProtocol: UserServiceConsumer {
  var delegate: LogInViewModelDelegate? { get set }

  func process(username: String)
  func process(password: String)
  func attemptLogin()
}
