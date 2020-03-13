//
//  MainChildViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/11/20.
//

import UIKit

final class MainChildViewController: UIViewController {
  private var label: UILabel! // swiftlint:disable:this implicitly_unwrapped_optional
}

// MARK: - View lifecycle

extension MainChildViewController {
  override func loadView() {
    view = UIView()
    view.backgroundColor = .systemBackground
    label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    label.textColor = .primary
    label.font = .boldSystemFont(ofSize: 60)
    label.text = NSLocalizedString("Dropp", comment: "Title of the app")
  }
}
