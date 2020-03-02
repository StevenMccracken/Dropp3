//
//  LogInViewModelProtocol.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/22/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

protocol LogInViewModelProtocol: UserServiceConsumer {
  var delegate: LogInViewModelDelegate? { get set }
  func process(username: String)
  func process(password: String)
  func attemptLogin()
}
