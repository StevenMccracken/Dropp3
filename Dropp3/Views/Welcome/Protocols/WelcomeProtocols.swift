//
//  WelcomeProtocols.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import UIKit

protocol WelcomeViewPage: ContainerConsumer {
  var delegate: WelcomeViewDelegate? { get set }
}

protocol WelcomeViewDelegate: AnyObject {
  func welcomeViewChild(_ child: WelcomeViewPage & UIViewController, didToggleLoading loading: Bool)
}
