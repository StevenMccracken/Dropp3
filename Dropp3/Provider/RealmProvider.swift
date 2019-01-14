//
//  RealmProvider.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
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

    func runTransaction(action: () -> Void) {
        guard isRealmAccessible else { return }
        let realm = try! Realm()
        realm.refresh()
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

    func clearAllData() {
        guard isRealmAccessible else { return }
        let realm = try! Realm()
        realm.refresh()
        try? realm.write {
            realm.deleteAll()
        }
    }
}

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
        Realm.Configuration.defaultConfiguration = Realm.Configuration()
    }
}
