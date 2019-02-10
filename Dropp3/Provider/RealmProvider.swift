//
//  RealmProvider.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmProvider {
  func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
    guard isRealmAccessible else { return nil }
    let realm = try! Realm()
    realm.refresh()
    let results = realm.objects(type)
    guard let predicate = predicate else { return results }
    return results.filter(predicate)
  }

  func object<T: Object>(_ type: T.Type, key: String) -> T? {
    guard isRealmAccessible else { return nil }
    let realm = try! Realm()
    realm.refresh()
    return realm.object(ofType: type, forPrimaryKey: key)
  }

  func add<T: Object>(_ data: [T], update: Bool = true) {
    guard isRealmAccessible else { return }
    let realm = try! Realm()
    realm.refresh()
    if realm.isInWriteTransaction {
      return realm.add(data, update: update)
    }

    try? realm.write {
      realm.add(data, update: update)
    }
  }

  func add<T: Object>(_ data: T, update: Bool = true) {
    add([data], update: update)
  }

  func runTransaction(withoutNotifying tokens: [NotificationToken?] = [], action: () -> Void) {
    guard isRealmAccessible else { return }
    let realm = try! Realm()
    realm.refresh()
    let validTokens = tokens.compactMap({ $0 })
    guard validTokens.isEmpty else {
      realm.beginWrite()
      action()
      try? realm.commitWrite(withoutNotifying: validTokens)
      return
    }

    try? realm.write {
      action()
    }
  }

  func delete<T: Object>(_ data: [T]) {
    let realm = try! Realm()
    realm.refresh()
    try? realm.write {
      realm.delete(data)
    }
  }

  func delete<T: Object>(_ data: T) {
    delete([data])
  }

  func observe<T: Object>(resultsForType type: T.Type, withPredicate predicate: NSPredicate? = nil, completion: @escaping (RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken? {
    guard isRealmAccessible else { return nil }
    let realm = try! Realm()
    realm.refresh()

    let finalResults: Results<T>
    let initialResults = realm.objects(type)
    if let predicate = predicate {
      finalResults = initialResults.filter(predicate)
    } else {
      finalResults = initialResults
    }

    return finalResults.observe(completion)
  }

  func clearAllData() {
    guard isRealmAccessible else { return }
    let realm = try! Realm()
    realm.refresh()
    try? realm.write {
      realm.deleteAll()
    }
  }
}

// MARK: - Metadata

extension RealmProvider {
  var isRealmAccessible: Bool {
    let isAccessible: Bool
    do {
      _ = try Realm()
      isAccessible = true
    } catch {
      debugPrint("Realm is not accessible")
      isAccessible = false
    }

    return isAccessible
  }

  func configure() {
    var configuration = Realm.Configuration()
    configuration.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration = configuration
    guard let location = Realm.Configuration.defaultConfiguration.fileURL?.absoluteString else { fatalError() }
    debugPrint("Realm location: \(location)")
  }
}
