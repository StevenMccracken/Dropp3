//
//  DroppServiceConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/7/19.
//

import Foundation

/// Something that consumes dropp services
protocol DroppServiceConsumer: ContainerConsumer {
  var droppService: DroppService { get }
}

// MARK: - Default implementation

extension DroppServiceConsumer {
  var droppService: DroppService { container.resolve(DroppService.self)! }
}
