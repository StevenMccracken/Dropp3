//
//  DroppService.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol DroppService {
    func getDropps(around location: Location, success: @escaping ([Dropp]) -> Void, failure: ((Error) -> Void)?)
}

struct DroppServiceAccessor {
    let shouldSucceed: Bool
    private struct Constants {
        static let errorCode = 900
        static let domain = "com.dropp.droppService"
    }
}

extension DroppServiceAccessor: DroppService {
    func getDropps(around location: Location, success: @escaping ([Dropp]) -> Void, failure: ((Error) -> Void)?) {
        let shouldSucceed = self.shouldSucceed
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1)) {
            if shouldSucceed {
                let dropps: [Dropp] = (0..<10).map { _ in
                    let location = Location(latitude: Double.random(in: 0..<100), longitude: Double.random(in: 0..<100))
                    let hasImage: Bool = Int.random(in: 0..<2) == 1
                    let message = "\(UUID().uuidString) \(UUID().uuidString) \(UUID().uuidString). \(UUID().uuidString).\n\(UUID().uuidString) \(UUID().uuidString)"
                    return Dropp(username: UUID().uuidString, location: location, hasImage: hasImage, message: message)
                }

                success(dropps)
            } else {
                let error = NSError(domain: Constants.domain, code: Constants.errorCode, userInfo: nil)
                failure?(error)
            }
        }
    }
}
