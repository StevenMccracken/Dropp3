//
//  UserProviderConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol UserProviderConsumer: ContainerConsumer {
  var userProvider: UserProvider { get }
}

extension UserProviderConsumer {
  var userProvider: UserProvider {
    return container.resolve(UserProvider.self)!
  }
}
