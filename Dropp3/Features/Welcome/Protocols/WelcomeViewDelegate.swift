//
//  WelcomeViewDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/1/20.
//

import Foundation

protocol WelcomeViewDelegate: AnyObject {
  func welcomeViewPage(_ page: WelcomeViewPage, didToggleLoading loading: Bool)
}
