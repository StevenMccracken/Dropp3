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

  // TODO: Remove
  func addDroppForCurrentUser()
  func addDroppForRandomUser()
}
