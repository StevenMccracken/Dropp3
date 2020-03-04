//
//  UserProviderConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//

import Foundation

/// Something that consumes a user provider
protocol UserProviderConsumer: ContainerConsumer {
  var userProvider: UserProvider { get }
}

// MARK: - Default implementation

extension UserProviderConsumer {
  var userProvider: UserProvider { container.resolve(UserProvider.self)! }
}
