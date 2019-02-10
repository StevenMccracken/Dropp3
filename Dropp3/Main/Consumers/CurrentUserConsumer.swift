//
//  CurrentUserConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

/// Something that wants access to the current user of the application
protocol CurrentUserConsumer: ContainerConsumer {
  /// The current user. Returns `nil` if there is no user signed in
  var currentUser: CurrentUser? { get }
}

// MARK: - Default current user implementation

extension CurrentUserConsumer {
  var currentUser: CurrentUser? {
    guard let user = container.resolve(CurrentUser.self), user != .noUser else { return nil }
    return user
  }
}
