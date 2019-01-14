//
//  ViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let provider: DroppProvider = MainDroppProvider(droppService: DroppServiceAccessor(shouldSucceed: true))
    provider.getDropps(around: Location(latitude: 0, longitude: 0))
  }
}
