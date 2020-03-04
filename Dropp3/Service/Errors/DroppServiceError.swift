//
//  DroppServiceError.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

struct DroppServiceError: LocalizedError {
  let code: ServiceErrorCode = .dropp

  enum NearbyDroppsError: Int, LocalizedError {
    case invalidLocation
  }
}
