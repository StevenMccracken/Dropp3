//
//  RealmProviderConsumer.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/7/19.
//

import Foundation

/// Something that consumes a realm provider
protocol RealmProviderConsumer: ContainerConsumer {
  var realmProvider: RealmProvider { get }
}

// MARK: - Default implementation

extension RealmProviderConsumer {
  var realmProvider: RealmProvider { container.resolve(RealmProvider.self)! }
}
