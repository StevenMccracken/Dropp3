//
//  NSObject+Clone.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/17/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

extension NSCopying {
  /// Copies the given object to another type
  func clone<T>() -> T {
    return self.copy() as! T
  }
}
