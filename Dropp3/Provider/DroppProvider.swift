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
protocol DroppProvider {
  /**
   Gets dropps around a given location
   - parameter location: the location to search around
   - parameter completion: closure returning dropp collection changes
   - returns: token that allows the `completion` parameter to receive calls. You must invalidate this token's strong reference at some point
   */
  @discardableResult
  func getDropps(around location: LocationProtocol, completion: ((RealmCollectionChange<Results<Dropp>>) -> Void)?) -> NotificationToken?
}

class MainDroppProvider: ContainerConsumer {
  var droppService: DroppService!
  var realmProvider: RealmProvider!
  init() {
    resolveDepedencies()
  }
}

// MARK: - DroppServiceAccessor

extension MainDroppProvider: DroppProvider {
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

// MARK: - DependencyContaining

extension MainDroppProvider: DependencyContaining {
  func resolveDepedencies() {
    droppService = container.resolve(DroppService.self)!
    realmProvider = container.resolve(RealmProvider.self)!
  }
}
