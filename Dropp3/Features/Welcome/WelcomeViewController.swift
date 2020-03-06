//
//  WelcomeViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//

import UIKit

final class WelcomeViewController: UIViewController {
  // MARK: - State

  private enum State: Int, CaseIterable {
    case signUp = 0
    case logIn = 1
  }

  // MARK: - State management

  private var pages: [WelcomeViewPage] = []
  private var state: State = .signUp {
    didSet {
      configurePage(for: state, from: oldValue)
      configurePageNavigation(for: state)
    }
  }
  private var loading: Bool = false {
    didSet {
      if loading {
        pages.forEach { $0.setEditing(false, animated: true) }
        [logInButton, signUpButton].forEach { $0.isEnabled = false }
        loadingIndicator.startAnimating()
        navigationItem.setRightBarButton(loadingIndicatorItem, animated: true)
      } else {
        [logInButton, signUpButton].forEach { $0.isEnabled = true }
        navigationItem.setRightBarButton(nil, animated: true)
        loadingIndicator.stopAnimating()
      }

      view.isUserInteractionEnabled = !loading
    }
  }

  // MARK: - Subviews

  @IBOutlet private weak var toolbar: UIToolbar!
  // swiftlint:disable:next implicitly_unwrapped_optional
  private var pageViewController: UIPageViewController! {
    didSet {
      pageViewController.delegate = self
      pageViewController.dataSource = self
    }
  }
  private lazy var loadingIndicator = UIActivityIndicatorView(style: .medium)
  private lazy var loadingIndicatorItem = UIBarButtonItem(customView: loadingIndicator)
  // swiftlint:disable line_length
  private lazy var signUpButton = UIBarButtonItem(title: NSLocalizedString("Sign Up", comment: "Button prompting user to switch to Sign Up view"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(switchPageAction(_:)))
  private lazy var logInButton = UIBarButtonItem(title: NSLocalizedString("Log In", comment: "Button prompting user to switch to Log In view"),
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(switchPageAction(_:)))
  // swiftlint:enable line_length
}

// MARK: - View lifecycle

extension WelcomeViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.pageViewController = (children.first as! UIPageViewController) // swiftlint:disable:this force_cast
    navigationItem.prompt = NSLocalizedString("Welcome", comment: "View header providing a welcoming message")

    // Confifigure pages
    let logInViewController: LogInViewController = .controller()
    let signUpViewController: SignUpViewController = .controller()
    logInViewController.delegate = self
    signUpViewController.delegate = self
    pages = [signUpViewController, logInViewController]
    state = .signUp
  }
}

// MARK: - View state configuration

private extension WelcomeViewController {
  private func configurePage(for state: State, from oldState: State) {
    let page: WelcomeViewPage = pages[state.rawValue]
    view.backgroundColor = page.view.backgroundColor
    let direction: UIPageViewController.NavigationDirection
    switch (oldState, state) {
    case (.signUp, .signUp), (.logIn, .logIn), (.signUp, .logIn):
      direction = .forward
    case (.logIn, .signUp):
      direction = .reverse
    }
    pageViewController.setViewControllers([page], direction: direction, animated: true, completion: nil)
  }

  private func configurePageNavigation(for state: State) {
    let items: [UIBarButtonItem]
    switch state {
    case .signUp:
      items = [.flexibileSpace, logInButton]
    case .logIn:
      items = [signUpButton, .flexibileSpace]
    }
    navigationItem.title = pages[state.rawValue].title
    toolbar.setItems(items, animated: true)
  }
}

// MARK: - UIPageViewControllerDataSource

extension WelcomeViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard viewController.isKind(of: LogInViewController.self) else { return nil }
    return pages.first
  }

  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard viewController.isKind(of: SignUpViewController.self) else { return nil }
    return pages.last
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int { pages.count }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let firstViewController = pageViewController.viewControllers?.first else { return 0 }
    return pages.firstIndex { $0 == firstViewController } ?? 0
  }
}

// MARK: - UIPageViewControllerDelegate

extension WelcomeViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    guard completed,
      let newViewController = pages.filter({ !previousViewControllers.contains($0) }).map({ $0 as UIViewController }).first,
      let pageIndex = pages.firstIndex(where: { $0 == newViewController }) else {
        return
    }
    state = State.allCases[pageIndex]
  }
}

// MARK: - WelcomeViewDelegate

extension WelcomeViewController: WelcomeViewDelegate {
  func welcomeViewPage(_ page: WelcomeViewPage, didToggleLoading loading: Bool) {
    self.loading = loading
  }
}

// MARK: - Actions

private extension WelcomeViewController {
  @objc
  func switchPageAction(_ sender: UIBarButtonItem) {
    switch sender {
    case logInButton:
      state = .logIn
    case signUpButton:
      state = .signUp
    default:
      fatalError("Unrecognized sender")
    }
  }
}
