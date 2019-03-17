//
//  UserServiceConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserServiceConsumer: ContainerConsumer {
  var userService: UserService { get }
}

extension UserServiceConsumer {
  var userService: UserService {
    return container.resolve(UserService.self)!
  }
}
