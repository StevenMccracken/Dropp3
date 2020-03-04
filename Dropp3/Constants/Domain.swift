//
//  Domain.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/19/19.
//

import Foundation

struct Domain {
  static let main = Domain(identifier: "com.dropp")
  static let userService = Domain(identifier: "\(main.identifier).userService")
  static let droppService = Domain(identifier: "\(main.identifier).droppService")

  let identifier: String
}
