//
//  DroppServiceConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/7/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol DroppServiceConsumer: ContainerConsumer {
  var droppService: DroppService { get }
}

extension DroppServiceConsumer {
  var droppService: DroppService {
    return container.resolve(DroppService.self)!
  }
}
