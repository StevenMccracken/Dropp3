//
//  UserProviderConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

/// Something that consumes a user provider
protocol UserProviderConsumer: ContainerConsumer {
  var userProvider: UserProvider { get }
}

// MARK: - Default implementation

extension UserProviderConsumer {
  var userProvider: UserProvider {
    return container.resolve(UserProvider.self)!
  }
}
