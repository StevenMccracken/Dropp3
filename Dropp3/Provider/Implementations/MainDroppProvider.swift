//
//  MainDroppProvider.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

final class MainDroppProvider: CurrentUserConsumer {
}

// MARK: - DroppProvider

extension MainDroppProvider: DroppProvider {
  // TODO: Remove
  func addDroppForCurrentUser() {
    guard let currentUser = self.currentUser else {
      debugPrint("Unable to resolve current user to add dropps")
      return
    }
    let dropp = Dropp(userID: currentUser.identifier,
                      location: Location(latitude: 1, longitude: 1),
                      hasImage: false,
                      message: UUID().uuidString)
    realmProvider.add(dropp, update: true)
    realmProvider.transaction(withoutNotifying: []) {
      currentUser.dropps.append(dropp)
    }
  }

  // TODO: Remove
  func addDroppForRandomUser() {
    let user: User = .random()
    realmProvider.add(user, update: true)
    let dropp = Dropp(userID: user.identifier,
                      location: Location(latitude: 1, longitude: 1),
                      hasImage: false,
                      message: UUID().uuidString)
    realmProvider.add(dropp, update: true)
    realmProvider.transaction(withoutNotifying: []) {
      user.dropps.append(dropp)
    }
  }

  func getDropps(around location: LocationProtocol,
                 completion: ((RealmCollectionChange<Results<Dropp>>) -> Void)?) -> NotificationToken? {
    var token: NotificationToken?
    if let completion = completion {
      token = realmProvider.observe(resultsForType: Dropp.self, withPredicate: nil, completion: completion)
    }

    droppService.getDropps(around: location, success: { [weak self] dropps in
      self?.realmProvider.add(dropps, update: true)
    }) { error in
      debugPrint(error)
    }

    return token
  }
}
