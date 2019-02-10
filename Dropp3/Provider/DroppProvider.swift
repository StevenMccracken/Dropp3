//
//  DroppProvider.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

/// Something that provides dropps
protocol DroppProvider: RealmProviderConsumer, DroppServiceConsumer {
  /**
   Gets dropps around a given location
   - parameter location: the location to search around
   - parameter completion: closure returning dropp collection changes
   - returns: token that allows the `completion` parameter to receive calls. You must invalidate this token's strong reference at some point
   */
  @discardableResult
  func getDropps(around location: LocationProtocol, completion: ((RealmCollectionChange<Results<Dropp>>) -> Void)?) -> NotificationToken?

  func addDroppForCurrentUser()
}

class MainDroppProvider: CurrentUserConsumer {
}

// MARK: - DroppServiceAccessor

extension MainDroppProvider: DroppProvider {
  func addDroppForCurrentUser() {
    guard let currentUser = self.currentUser else { fatalError() }
    let dropp = Dropp(user: currentUser, location: Location(latitude: 1, longitude: 1), hasImage: false, message: UUID().uuidString)
    realmProvider.runTransaction {
      currentUser.dropps.append(dropp)
    }
  }

  func getDropps(around location: LocationProtocol, completion: ((RealmCollectionChange<Results<Dropp>>) -> Void)?) -> NotificationToken? {
    var token: NotificationToken?
    if let completion = completion {
      token = realmProvider.observe(resultsForType: Dropp.self, completion: completion)
    }

    droppService.getDropps(around: location, success: { [weak self] dropps in
      self?.realmProvider.add(dropps, update: true)
    }) { error in
      debugPrint(error)
    }

    return token
  }
}
