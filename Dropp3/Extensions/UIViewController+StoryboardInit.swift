//
//  UIViewController+StoryboardInit.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/2/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

extension UIViewController {
  /**
   Instantiates a view controller from a storyboard
   - parameter storyboardName: The name of the storyboard where the view controller is defined. If `nil`, the view controller's class name will be
   interpreted as the storyboad name, without the "Controller". If "Controller" is not in the name, then you must provide a storyboard name. Default is `nil`
   - parameter bundle: the bundle for the view controller. If `nil`, the view controller's `classForCoder` is used for the bundle. Default is `nil`
   - parameter identifier: the identifier of the view controller within the storyboard. If `nil`, the initial view controller is used to find the view controller in
   the storyboard. Otherwise, it is assumed the view controller is the initial view controller of the storyboard. Default is `nil`
   - returns: the view controller
   */
  static func controller<T: UIViewController>(from storyboardName: String? = nil,
                                              bundle: Bundle? = nil,
                                              with identifier: String? = nil) -> T {
    let name: String
    if let storyboardName = storyboardName {
      name = storyboardName
    } else {
      var className = String(describing: T.self)
      guard let controllerRange = className.range(of: "Controller") else {
        fatalError("View controller did not contain word \"Controller\"")
      }

      className.removeSubrange(controllerRange)
      name = className
    }

    let validBundle = bundle ?? Bundle(for: T.classForCoder())
    let storyboard = UIStoryboard(name: name, bundle: validBundle)
    let viewController: UIViewController
    if let identifier = identifier {
      viewController = storyboard.instantiateViewController(withIdentifier: identifier)
    } else {
      viewController = storyboard.instantiateInitialViewController()!
    }

    return viewController as! T
  }
}
