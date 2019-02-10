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
  let container = Container() { container in
    container.register(RealmProvider.self) { _ in RealmProvider() }
    container.register(CurrentUser.self) { resolver in
      let currentUsers = resolver.resolve(RealmProvider.self)?.objects(CurrentUser.self)
      return currentUsers?.first ?? .noUser
    }

    container.register(DroppProvider.self) { _ in MainDroppProvider() }
    container.register(DroppService.self) { _ in DroppServiceAccessor() }
    container.register(NearbyDroppsViewModelProtocol.self) { _ in NearbyDroppsViewModel() }
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    applyConfigurations()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

// MARK: - One time configurations

extension AppDelegate {
  private func applyConfigurations() {
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
