//
//  ContainerConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/20/19.
//

import Foundation
import Swinject

/// Something that wants access to a depedency container
protocol ContainerConsumer {
  /// The dependency container. Default is the main application's container
  var container: Container { get }
}

// MARK: - Default container implementation

extension ContainerConsumer {
  var container: Container { AppDelegate.current.container }
}
