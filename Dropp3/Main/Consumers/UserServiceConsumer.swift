//
//  UserServiceConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

/// Something that consumes user services
protocol UserServiceConsumer: ContainerConsumer {
  var userService: UserService { get }
}

// MARK: - Default implementation

extension UserServiceConsumer {
  var userService: UserService { container.resolve(UserService.self)! }
}
