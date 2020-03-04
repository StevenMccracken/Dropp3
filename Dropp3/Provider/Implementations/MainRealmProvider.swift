//
//  RealmProvider.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//

import Foundation
import RealmSwift

struct MainRealmProvider {
  private var realm: Realm? {
    let realm: Realm?
    do {
      realm = try Realm()
    } catch let error {
      debugPrint("Failed to access Realm with error: \(error.localizedDescription)")
      realm = nil
    }
    return realm
  }
}

// MARK: - RealmProvider

extension MainRealmProvider: RealmProvider {
  func add<T: Object>(_ object: T, update: Bool = true) {
    add([object], update: update)
  }

  func add<T: Object>(_ objects: [T], update: Bool = true) {
    guard let realm = self.realm else { return }
    realm.refresh()
    do {
      try realm.write { realm.add(objects, update: update ? .all : .modified) }
    } catch let error {
      debugPrint("Failed to perform Realm write with error: \(error.localizedDescription)")
    }
  }

  func object<T: Object>(_ type: T.Type, key: String) -> T? {
    guard let realm = self.realm else { return nil }
    realm.refresh()
    return realm.object(ofType: type, forPrimaryKey: key)
  }

  func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
    guard let realm = self.realm else { return nil }
    realm.refresh()
    let results = realm.objects(type)
    guard let predicate = predicate else { return results }
    return results.filter(predicate)
  }

  func observe<T: Object>(resultsForType type: T.Type,
                          withPredicate predicate: NSPredicate? = nil,
                          completion: @escaping (RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken? {
    guard let realm = self.realm else { return nil }
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
    guard let realm = self.realm else { return }
    realm.refresh()
    do {
      try realm.write { realm.deleteAll() }
    } catch let error {
      debugPrint("Failed to perform Realm write with error: \(error.localizedDescription)")
    }
  }

  func delete<T: Object>(_ object: T) {
    delete([object])
  }

  func delete<T: Object>(_ objects: [T]) {
    guard let realm = self.realm else { return }
    realm.refresh()
    do {
      try realm.write { realm.delete(objects) }
    } catch let error {
      debugPrint("Failed to perform Realm write with error: \(error.localizedDescription)")
    }
  }

  func transaction(withoutNotifying tokens: [NotificationToken?] = [], transaction: () -> Void) {
    guard let realm = self.realm else { return }
    realm.refresh()
    let validTokens = tokens.compactMap { $0 }
    if validTokens.isEmpty {
      do {
        try realm.write { transaction() }
      } catch let error {
        debugPrint("Failed to perform Realm write with error: \(error.localizedDescription)")
      }
    } else {
      realm.beginWrite()
      transaction()
      do {
        try realm.commitWrite(withoutNotifying: validTokens)
      } catch let error {
        debugPrint("Failed to perform Realm write with error: \(error.localizedDescription)")
      }
    }
  }

  func configure() {
    var configuration = Realm.Configuration()
    configuration.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration = configuration
    guard let location = Realm.Configuration.defaultConfiguration.fileURL else {
      debugPrint("Unable to find Realm location because fileURL was nil!")
      return
    }
    debugPrint("Realm location: \(location.absoluteString)")
  }
}
