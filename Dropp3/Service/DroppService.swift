//
//  DroppService.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

struct DroppServiceError: LocalizedError {
  let code: ServiceErrorCode = .dropp

  enum NearbyDroppsError: Int, LocalizedError {
    case invalidLocation
  }
}

/// Something that provides services for dropps
protocol DroppService {
  /**
   Retrieves dropps around a given location
   - parameter location: the location to search around
   - parameter success: closure returning list of dropps around the given location
   - parameter failure: closure returning errors that occurred while searching
   */
  func getDropps(around location: LocationProtocol,
                 success: @escaping ([Dropp]) -> Void,
                 failure: ((DroppServiceError.NearbyDroppsError) -> Void)?)
}

class DroppServiceAccessor: RealmProviderConsumer {
}

// MARK: - DroppService

extension DroppServiceAccessor: DroppService {
  func getDropps(around location: LocationProtocol,
                 success: @escaping ([Dropp]) -> Void,
                 failure: ((DroppServiceError.NearbyDroppsError) -> Void)?) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
      guard let `self` = self else { return }
      let user = User(username: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString)
      let dropps: [Dropp] = (0..<10).map { _ in
        let location = Location(latitude: Double.random(in: 0..<100), longitude: Double.random(in: 0..<100))
        let message = "\(UUID().uuidString) \(UUID().uuidString) \(UUID().uuidString). \(UUID().uuidString).\n\(UUID().uuidString) \(UUID().uuidString)"
        return Dropp(userID: user.identifier, location: location, hasImage: Bool.random(), message: message)
      }

      self.realmProvider.add(user)
      self.realmProvider.add(dropps)
      self.realmProvider.runTransaction {
        user.dropps.append(objectsIn: dropps)
      }

      success(dropps)
    }
  }
}
