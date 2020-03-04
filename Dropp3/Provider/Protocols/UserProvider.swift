//
//  UserProvider.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

/// Something that provides users
protocol UserProvider: RealmProviderConsumer {
  func user(for identifier: String) -> User?
}
