//
//  WelcomeProtocols.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import UIKit

protocol WelcomeViewPage: UserServiceConsumer, UIViewController {
  var delegate: WelcomeViewDelegate? { get set }
}
