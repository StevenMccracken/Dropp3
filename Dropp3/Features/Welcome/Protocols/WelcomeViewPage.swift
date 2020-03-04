//
//  WelcomeViewPage.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/9/19.
//

import Foundation
import UIKit

protocol WelcomeViewPage: UserServiceConsumer, UIViewController {
  var delegate: WelcomeViewDelegate? { get set }
}
