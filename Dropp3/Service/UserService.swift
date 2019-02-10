//
//  UserService.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/28/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserService {
  func logIn(username: String, password: String, success: (() -> Void)?, failure: @escaping (Error) -> Void)
  func signUp(username: String, password: String, firstName: String, lastName: String, success: (() -> Void)?, failure: @escaping (Error) -> Void)
}

class UserServiceAccessor {
  
}
