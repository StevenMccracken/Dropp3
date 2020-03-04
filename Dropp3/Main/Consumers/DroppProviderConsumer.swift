//
//  DroppProviderConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/7/19.
//

import Foundation

/// Something that consumes a dropp provider
protocol DroppProviderConsumer: ContainerConsumer {
  var droppProvider: DroppProvider { get }
}

// MARK: - Default implementation

extension DroppProviderConsumer {
  var droppProvider: DroppProvider { container.resolve(DroppProvider.self)! }
}
