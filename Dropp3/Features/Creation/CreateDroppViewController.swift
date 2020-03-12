//
//  CreateDroppViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 3/5/20.
//

import MapKit
import UIKit

final class CreateDroppViewController: UIViewController, CurrentUserConsumer {
  // MARK: - State

  private enum State: Int, CaseIterable, IteratorProtocol {
    case text = 0
    case location = 1
    case media = 2

    typealias Element = State
    mutating func next() -> CreateDroppViewController.State? {
      self == State.allCases.last ? State.allCases.first : State.allCases[self.rawValue + 1]
    }
  }

  private var state: State = .text {
    didSet {
      view.subviews.first?.removeFromSuperview()
      NSLayoutConstraint.deactivate(view.constraints)
      switch state {
      case .text:
        addTextView()
      case .location:
        addMapView()
      case .media:
        break
      }
    }
  }

  // MARK: - Subviews

  private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.translatesAutoresizingMaskIntoConstraints = false
    return mapView
  }()
}

// MARK: - View lifecycle

extension CreateDroppViewController {
  override func loadView() {
    view = UIView()
    view.backgroundColor = .systemBackground
    state = State.allCases.first!
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    isModalInPresentation = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
    // swiftlint:disable:next line_length
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Next", comment: "Button prompting user to navigate to the next step"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(nextAction(_:)))
  }
}

// MARK: - View configuration

private extension CreateDroppViewController {
  func addTextView() {
    view.addSubview(textView)
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: view.topAnchor),
      textView.leftAnchor.constraint(equalTo: view.leftAnchor),
      textView.rightAnchor.constraint(equalTo: view.rightAnchor),
      textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
    ])
  }

  func addMapView() {
    view.addSubview(mapView)
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
      mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Actions

private extension CreateDroppViewController {
  @objc
  func cancelAction(_ sender: UIBarButtonItem) {
    // swiftlint:disable line_length
    let confirmAction = UIAlertController(title: NSLocalizedString("Are you sure you want to cancel creating your dropp?",
                                                                   comment: "Title confirming the user wants to cancel"),
                                          message: NSLocalizedString("You will lose all progress.",
                                                                     comment: "Message informing the user that canceling will lose all progress"),
                                          preferredStyle: .actionSheet)
    // swiftlint:enable line_length
    confirmAction.addAction(UIAlertAction(title: "Cancel creation", style: .destructive) { [weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    })
    confirmAction.addAction(UIAlertAction(title: "Continue creating", style: .cancel, handler: nil))

    confirmAction.popoverPresentationController?.barButtonItem = sender
    present(confirmAction, animated: true, completion: nil)
  }

  @objc
  func nextAction(_ sender: UIBarButtonItem) {
    state = state.next()!
  }
}
