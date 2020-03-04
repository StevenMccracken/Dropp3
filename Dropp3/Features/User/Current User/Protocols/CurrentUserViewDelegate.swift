//
//  CurrentUserViewDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/3/20.
//

import Foundation

protocol CurrentUserViewDelegate: AnyObject {
  func toggleEditButton(enabled: Bool)
  func toggleDeleteButton(enabled: Bool)
}
