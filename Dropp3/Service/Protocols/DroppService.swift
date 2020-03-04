//
//  DroppService.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

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
