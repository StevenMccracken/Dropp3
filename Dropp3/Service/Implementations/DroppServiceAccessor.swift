//
//  DroppServiceAccessor.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

/// Main implementation of the `DroppService` protocol
final class DroppServiceAccessor: RealmProviderConsumer {
}

// MARK: - DroppService

extension DroppServiceAccessor: DroppService {
  func getDropps(around location: LocationProtocol,
                 success: @escaping ([Dropp]) -> Void,
                 failure: ((DroppServiceError.NearbyDropps) -> Void)?) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
      guard let self = self else { return }
      let user = User(username: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString)
      let dropps: [Dropp] = (0..<10).map { _ in
        let location = Location(latitude: Double.random(in: 0..<100), longitude: Double.random(in: 0..<100))
        // swiftlint:disable:next line_length
        let message = "\(UUID().uuidString) \(UUID().uuidString) \(UUID().uuidString). \(UUID().uuidString).\n\(UUID().uuidString) \(UUID().uuidString)"
        return Dropp(userID: user.identifier, location: location, hasImage: Bool.random(), message: message)
      }

      self.realmProvider.add(user, update: true)
      self.realmProvider.add(dropps, update: true)
      self.realmProvider.transaction(withoutNotifying: []) {
        user.dropps.append(objectsIn: dropps)
      }

      success(dropps)
    }
  }
}
