//
//  AppDelegate.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/11/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  /// The depedency container for the application
  let container = Container() { container in
    container.register(RealmProvider.self) { _ in RealmProvider() }
    container.register(CurrentUser.self) { resolver in
      /// There must always be a `nonnil` current user instance
      let currentUsers = resolver.resolve(RealmProvider.self)!.objects(CurrentUser.self)!
      return currentUsers.first ?? .noUser
    }

    container.register(UserProvider.self) { _ in MainUserProvider() }
    container.register(UserService.self) { _ in UserServiceAccessor() }
    container.register(DroppProvider.self) { _ in MainDroppProvider() }
    container.register(DroppService.self) { _ in DroppServiceAccessor() }
    container.register(NearbyDroppsViewModelProtocol.self) { _ in NearbyDroppsViewModel() }
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    applyConfigurations()
    return true
  }
}

// MARK: - One time configurations

private extension AppDelegate {
  /// Configures registered dependencies for initial use
  func applyConfigurations() {
    container.resolve(RealmProvider.self)!.configure()
  }
}

// MARK: - Current convenience

extension AppDelegate {
  /// The application's current custom application delegate. Can be called from any thread
  static var current: AppDelegate {
    if Thread.isMainThread {
      return UIApplication.shared.delegate as! AppDelegate
    }

    var delegate: UIApplicationDelegate!
    DispatchQueue.main.sync {
      delegate = UIApplication.shared.delegate
    }

    return delegate as! AppDelegate
  }
}
