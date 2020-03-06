//
//  UserViewProtocols.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/12/19.
//

import Foundation

protocol UserViewModelProtocol {
  var user: User { get }
  var title: String { get }
  var delegate: UserViewModelDelegate? { get set }

  var sections: Int { get }

  func numberOfRows(forSection section: Int) -> Int

  func shouldRefreshData()
  func didRefreshData()
}
