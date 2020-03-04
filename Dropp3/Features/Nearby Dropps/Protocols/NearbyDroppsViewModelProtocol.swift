//
//  NearbyDroppsViewModelProtocol.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

protocol NearbyDroppsViewModelProtocol: RealmProviderConsumer, DroppProviderConsumer {
  var dropps: Results<Dropp> { get }
  var delegate: NearbyDroppsViewModelDelegate? { get set }

  func shouldRefreshData()
  func controller(forRow row: Int) -> UserViewController
}
