//
//  RealmProvider.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//

import Foundation
import RealmSwift

/// Defines how to interact with a database backed by Realm
protocol RealmProvider {
  // MARK: - Create/Update

  /**
   Adds or updates the provided object to the database
   - parameter object: the object to add or update
   - parameter update: whether or not the provided object should be updated. Pass `true` if the object already existed so that any changed
   fields will be updated. Pass `false` if the object is new so that it will be inserted
   */
  func add<T: Object>(_ object: T, update: Bool)

  /**
   Adds or updates the provided objects to the database
   - parameter objects: the objects to add or update
   - parameter update: whether or not the provided objects should be updated. Pass `true` if the objects already existed so that any changed
   fields will be updated. Pass `false` if the objects is new so that it will be inserted
   */
  func add<T: Object>(_ objects: [T], update: Bool)

  // MARK: - Read

  /**
   Queries the database for an object matching the given type and key
   - parameter type: the type of the object
   - parameter key: the primary key of the object
   - returns: the object if it existed, or `nil`
   */
  func object<T: Object>(_ type: T.Type, key: String) -> T?

  /**
   Queries the database for a homogeneous collection of objects matching the given type and predicate
   - parameter type: the type of the objects
   - parameter predicate: the predicate to filter the collection with. Pass `nil` to receive the entire collection
   - returns: the collection of objects if they existed, or `nil`. Could be an empty collection
   */
  func objects<T: Object>(_ type: T.Type, predicate: NSPredicate?) -> Results<T>?

  /**
   Queries the database for a homogeneous collection of objects matching the given type and predicate, and continually monitors the
   collection's status. Use this to receive callbacks about changes to the collection, including the initial query, updates, additions,
   and/or deletions
   - parameter type: the type of the objects
   - parameter predicate: the predicate to filter the collection with. Pass `nil` to receive the entire collection
   - parameter completion: the callback to receive changes to the collection, including the initial query, updates, additions, and/or
   deletions
   - returns: token that must be held strongly for the callback to be triggered. Invalidate the token to stop receiving callbacks
   */
  func observe<T: Object>(resultsForType type: T.Type,
                          withPredicate predicate: NSPredicate? ,
                          completion: @escaping (RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken?

  // MARK: - Delete

  /// Clears the entire database
  func clearAllData()

  /**
   Deletes the given object
   - parameter object: the object to delete
   */
  func delete<T: Object>(_ object: T)

  /**
   Deletes the given objects
   -parameter objects: the objects to delete
   */
  func delete<T: Object>(_ objects: [T])

  // MARK: - General

  /**
   Performs the given database transaction without notifiying given tokens. Use this when the work of the transaction is already updated in
   the UI immediately
   - parameter tokens: the tokens to bypass notifications for
   - parameter transaction: the transaction to run
   */
  func transaction(withoutNotifying tokens: [NotificationToken?], transaction: () throws -> Void)

  // MARK: - Meta

  /// Configuration for the Realm database. Should only be called once
  func configure()
}
