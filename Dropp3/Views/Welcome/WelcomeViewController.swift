//
//  WelcomeViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/3/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit

class WelcomeViewController: UIPageViewController {
  typealias Page = WelcomeViewPage & UIViewController
  private var pages: [Page] = []

  // MARK: - Loading

  private var loading: Bool = false {
    didSet {
      if loading {
        view.endEditing(true)
        loadingIndicator.startAnimating()
        navigationItem.setRightBarButton(loadingIndicatorItem, animated: true)
      } else {
        navigationItem.setRightBarButton(nil, animated: true)
        loadingIndicator.stopAnimating()
      }

      view.isUserInteractionEnabled = !loading
    }
  }

  private lazy var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
  private lazy var loadingIndicatorItem: UIBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
}

// MARK: - View lifecycle

extension WelcomeViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpPages()
    setUpNavigation()
    setUpPageViewController()
  }

  private func setUpPages() {
    let logInViewController: LogInViewController = .controller()
    let signUpViewController: SignUpViewController = .controller()
    logInViewController.delegate = self
    signUpViewController.delegate = self
    pages = [signUpViewController, logInViewController]
  }

  private func setUpNavigation() {
    navigationItem.prompt = pages.first?.title
  }

  private func setUpPageViewController() {
    delegate = self
    dataSource = self
    let page: Page! = pages.first
    view.backgroundColor = page.view.backgroundColor
    setViewControllers([page], direction: .forward, animated: true, completion: nil)
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

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pages.count
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let firstViewController = viewControllers?.first else { return 0 }
    return pages.firstIndex { $0 == firstViewController } ?? 0
  }
}

// MARK: - UIPageViewControllerDelegate

extension WelcomeViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    guard completed else { return }
    let newViewController = pages.filter { !previousViewControllers.contains($0) }.first
    navigationItem.prompt = newViewController?.title
    view.backgroundColor = newViewController?.view.backgroundColor
  }
}

// MARK: - WelcomeViewDelegate

extension WelcomeViewController: WelcomeViewDelegate {
  func welcomeViewChild(_ child: UIViewController & WelcomeViewPage, didToggleLoading loading: Bool) {
    self.loading = loading
  }
}
