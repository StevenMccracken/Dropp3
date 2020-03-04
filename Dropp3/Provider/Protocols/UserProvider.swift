//
//  UserProvider.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//

import Foundation

/// Something that provides users
protocol UserProvider: RealmProviderConsumer {
  func user(for identifier: String) -> User?
}
