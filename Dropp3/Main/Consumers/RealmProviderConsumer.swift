//
//  RealmProviderConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/7/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation

protocol RealmProviderConsumer: ContainerConsumer {
  var realmProvider: RealmProvider { get }
}

extension RealmProviderConsumer {
  var realmProvider: RealmProvider {
    return container.resolve(RealmProvider.self)!
  }
}
