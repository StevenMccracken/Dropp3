//
//  UserServiceConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
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
