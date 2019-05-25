//
//  DroppProviderConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/7/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

/// Something that consumes a dropp provider
protocol DroppProviderConsumer: ContainerConsumer {
  var droppProvider: DroppProvider { get }
}

// MARK: - Default implementation

extension DroppProviderConsumer {
  var droppProvider: DroppProvider {
    return container.resolve(DroppProvider.self)!
  }
}
