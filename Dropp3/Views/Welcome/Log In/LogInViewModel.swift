//
//  LogInViewModel.swift
//  Dropp3
//
//  Created by Steven McCracken on 5/25/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import ReactiveSwift

class LogInViewModel: UserServiceConsumer {
  let logInEnabled: Property<Bool>
  var username: MutableProperty<String> = MutableProperty("")
  var password: MutableProperty<String> = MutableProperty("")

  private(set) var logInSignal: Signal<Bool, Error>!
  private(set) var logInAction: Action<Void, Bool, Error>!

  init() {
    logInEnabled = Property.combineLatest(
      username.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 },
      password.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10 }).map { $0 && $1 }

    logInSignal = Signal { [unowned self] (subscriber, _) in
      self.userService.logIn(username: self.username.value, password: self.password.value, success: {
        subscriber.send(value: true)
        subscriber.sendCompleted()
      }, failure: { error in
        subscriber.send(value: false)
        subscriber.send(error: error)
      })
    }

    logInAction = Action(enabledIf: logInEnabled) { [unowned self] in return self.logInSignal.producer }
  }
}
