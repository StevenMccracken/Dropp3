//
//  UIViewController+StoryboardInit.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/2/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

extension UIViewController {
  static func controller<T: UIViewController>(from storyboardName: String? = nil, bundle: Bundle? = nil, with identifier: String? = nil) -> T {
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
