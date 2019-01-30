//
//  LocationProtocol.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

@objc protocol LocationProtocol: AnyObject {
  var latitude: Double { get set }
  var longitude: Double { get set }
}
