//
//  ListViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/28/19.
//

import UIKit

class ListViewController: UIViewController {
  // swiftlint:disable:next convenience_type
  private struct Constants {
    static let cellIdentifier = UUID().uuidString
  }

  // MARK: - Item properties

  private let itemCount: Int
  private var selectedIndexes: Set<Int> = []

  // MARK: - Item closures

  private var singleSelectionClosure: ((Int) -> Void)?
  private var multiSelectionClosure: (([Int]) -> Void)?
  private let itemClosure: ((Int) -> (title: String, subtitle: String?))

  // MARK: - Views

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.tableFooterView = UIView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    return tableView
  }()

  // MARK: - Init

  init(numberOfItems: Int,
       initialSelectedIndex: Int? = nil,
       itemForIndex: @escaping (Int) -> (title: String, subtitle: String?),
       didSelectItemAtIndex: ((Int) -> Void)? = nil) {
    itemCount = numberOfItems
    itemClosure = itemForIndex
    singleSelectionClosure = didSelectItemAtIndex
    if let index = initialSelectedIndex {
      selectedIndexes.insert(index)
    }

    super.init(nibName: nil, bundle: nil)
    setUpViews()
  }

  init(numberOfItems: Int,
       initialSelectedIndexes: [Int] = [],
       itemForIndex: @escaping (Int) -> (title: String, subtitle: String?),
       didSelectItemsAtIndexes: (([Int]) -> Void)? = nil) {
    itemCount = numberOfItems
    itemClosure = itemForIndex
    multiSelectionClosure = didSelectItemsAtIndexes

    super.init(nibName: nil, bundle: nil)
    initialSelectedIndexes.forEach { selectedIndexes.insert($0) }
    setUpViews()
  }

  required init?(coder aDecoder: NSCoder) {
    itemCount = 0
    itemClosure = { _ in ("", nil) }
    super.init(coder: aDecoder)
  }
}

// MARK: - View configuration

private extension ListViewController {
  func setUpViews() {
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      ])
  }
}

// MARK: - Helpers

private extension ListViewController {
  func isIndexPathSelected(_ index: IndexPath) -> Bool { selectedIndexes.contains(index.row) }
}

// MARK: - View lifecycle

extension ListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    navigationItem.title = "Select an Item"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                       target: self,
                                                       action: #selector(cancelAction(_:)))
    if multiSelectionClosure != nil {
      let title = NSLocalizedString("Apply", comment: "Button informing the user that changes will be applied")
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: title,
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(applyAction(_:)))
      navigationItem.rightBarButtonItem?.isEnabled = false
    }
  }

  override func present(from presentingViewController: UIViewController,
                        barButtonItem: UIBarButtonItem? = nil,
                        sourceView: UIView? = nil,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {
    let navigationController = UINavigationController(rootViewController: self)
    navigationController.navigationBar.isTranslucent = false
    navigationController.present(from: presentingViewController,
                                 barButtonItem: barButtonItem,
                                 sourceView: sourceView,
                                 animated: animated,
                                 completion: completion)
  }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { itemCount }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
    let item = itemClosure(indexPath.row)
    cell.textLabel?.text = item.title
    cell.detailTextLabel?.text = item.subtitle
    cell.accessoryType = isIndexPathSelected(indexPath) ? .checkmark : .none
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    defer {
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    guard multiSelectionClosure != nil else {
      if isIndexPathSelected(indexPath) {
        return
      }

      singleSelectionClosure?(indexPath.row)
      dismiss(animated: true, completion: nil)
      return
    }

    let row = indexPath.row
    if isIndexPathSelected(indexPath) {
      selectedIndexes.remove(row)
    } else {
      selectedIndexes.insert(row)
    }

    navigationItem.rightBarButtonItem?.isEnabled = !selectedIndexes.isEmpty
  }
}

// MARK: - Actions

extension ListViewController {
  @objc
  private func applyAction(_ sender: UIBarButtonItem) {
    multiSelectionClosure?(selectedIndexes.sorted())
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func cancelAction(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}

extension UIViewController {
  @objc
  func present(from presentingViewController: UIViewController,
               barButtonItem: UIBarButtonItem? = nil,
               sourceView: UIView? = nil,
               animated: Bool = true,
               completion: (() -> Void)? = nil) {
    modalPresentationStyle = .popover
    if let barButtonItem = barButtonItem {
      popoverPresentationController?.barButtonItem = barButtonItem
    } else if let sourceView = sourceView {
      popoverPresentationController?.sourceView = sourceView
      popoverPresentationController?.sourceRect = sourceView.bounds
    } else {
      modalPresentationStyle = .overFullScreen
    }

    presentingViewController.present(self, animated: animated, completion: completion)
  }
}
