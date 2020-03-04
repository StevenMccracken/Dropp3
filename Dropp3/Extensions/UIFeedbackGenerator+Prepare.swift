//
//  UIFeedbackGenerator+Prepare.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import UIKit

extension UIFeedbackGenerator {
  func prepare(for impact: () -> Void) {
    prepare()
    impact()
  }
}
