//
//  LocationProtocol.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/11/19.
//

import Foundation

@objc protocol LocationProtocol: AnyObject {
  var latitude: Double { get set }
  var longitude: Double { get set }
}
