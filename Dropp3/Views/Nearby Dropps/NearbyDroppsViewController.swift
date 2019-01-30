//
//  NearbyDroppsViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/20/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

private struct Constants {
  static let cellID = "cellID"
  static let showUserSegue = "showUserSegue"
  static let tableViewFadeAlphaDuration = 0.5
  static let tableViewFadeHiddenDuration = 0.15
  static func hiddenTitle(for dropp: Dropp) -> String {
    return dropp.hidden ? "Unhide" : "Hide"
  }
}

class NearbyDroppsViewController: UIViewController, ContainerConsumer {

  // MARK: - Data

  private var token: NotificationToken?
  private var droppProvider: DroppProvider!
  private var realmProvider: RealmProvider!
  private var dropps: Results<Dropp> {
    return realmProvider.objects(Dropp.self)!
  }

  private var showsListView: Bool {
    get {
      return !tableView.isHidden
    }
    set {
      UIView.transition(with: tableView, duration: Constants.tableViewFadeHiddenDuration, options: .transitionCrossDissolve, animations: { [weak self] in
        self?.tableView.isHidden = !newValue
        self?.listButton.isEnabled = !newValue
      })

      UIView.animate(withDuration: Constants.tableViewFadeAlphaDuration) { [weak self] in
        self?.tableView.alpha = newValue ? 1 : 0
      }
    }
  }

  // MARK: - Views

  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var tableView: UITableView!

  // MARK: - Buttons

  @IBOutlet var locateButton: UIBarButtonItem!
  @IBOutlet var refreshButton: UIBarButtonItem!
  @IBOutlet weak var listButton: UIBarButtonItem!

  // MARK: - Gesture recognizers

  private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(mapUserInteractionAction(_:)))
    gestureRecognizer.delegate = self
    return gestureRecognizer
  }()

  private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapUserInteractionAction(_:)))
    gestureRecognizer.delegate = self
    gestureRecognizer.numberOfTapsRequired = 2
    return gestureRecognizer
  }()

  private lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
    let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(mapUserInteractionAction(_:)))
    gestureRecognizer.delegate = self
    return gestureRecognizer
  }()

  // MARK: - Init

  deinit {
    token?.invalidate()
  }
}

// MARK: - View lifecycle

extension NearbyDroppsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    resolveDepedencies()
    configureViews()
    performInitialFetch()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(action))
  }

  @objc private func action() {
    let dropps = self.dropps
    let listViewController = ListViewController(numberOfItems: dropps.count, initialSelectedIndexes: nil, itemForIndex: {
      let dropp = dropps[$0]
      return (dropp.identifier, dropp.user?.fullName)
    }, didSelectItemsAtIndexes: { index in
      print(index)
    })

    listViewController.present(from: self, barButtonItem: navigationItem.rightBarButtonItem, animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setToolbarHidden(true, animated: false)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if segue.identifier == Constants.showUserSegue {
      guard let destination = segue.destination as? UserViewController,
        let cell = sender as? NearbyDroppTableViewCell,
        let indexPath = tableView.indexPath(for: cell) else {
          fatalError()
      }

      destination.user = dropps[indexPath.row].user!
      navigationController?.setToolbarHidden(true, animated: true)
    }
  }
}

// MARK: - View configuration

extension NearbyDroppsViewController {
  private func configureViews() {
    configureMapView()
    configureTableView()
  }

  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(NearbyDroppTableViewCell.nib, forCellReuseIdentifier: Constants.cellID)
  }

  private func configureMapView() {
    mapView.delegate = self
    [panGestureRecognizer, doubleTapGestureRecognizer, pinchGestureRecognizer].forEach { mapView.addGestureRecognizer($0) }
  }
}

// MARK: - UITableViewDataSource

extension NearbyDroppsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dropps.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? NearbyDroppTableViewCell else {
      fatalError()
    }

    cell.delegate = self
    cell.provide(dropp: dropps[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let dropp = dropps[indexPath.row]
    let hideAction = UITableViewRowAction(style: .normal, title: Constants.hiddenTitle(for: dropp)) { [weak self] (_, indexPath) in
      self?.realmProvider.runTransaction {
        dropp.hidden.toggle()
      }
    }

    return [hideAction]
  }
}

// MARK: - UITableViewDelegate

extension NearbyDroppsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - MKMapViewDelegate

extension NearbyDroppsViewController: MKMapViewDelegate {
}

// MARK: - User interaction

extension NearbyDroppsViewController {
  @IBAction private func listButtonAction(_ sender: UIBarButtonItem) {
    showsListView = true
  }

  @IBAction private func refreshAction(_ sender: UIBarButtonItem) {
    droppProvider.getDropps(around: Location(latitude: 0, longitude: 0), completion: nil)
  }

  @IBAction private func locateAction(_ sender: UIBarButtonItem) {
    print("locate")
  }

  @objc private func mapUserInteractionAction(_ gestureRecognizer: UIGestureRecognizer) {
    if gestureRecognizer.state == .began, showsListView {
      showsListView = false
    }
  }
}

// MARK: - UIGestureRecognizerDelegate

extension NearbyDroppsViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

// MARK: - Data fetching

extension NearbyDroppsViewController {
  private func performInitialFetch() {
    token = droppProvider.getDropps(around: Location(latitude: 0, longitude: 0)) { [weak self] collectionChange in
      guard let `self` = self, let tableView = self.tableView else { return }
      switch collectionChange {
      case .initial(_):
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        tableView.performBatchUpdates({
          [(tableView.insertRows, insertions),
           (tableView.deleteRows, deletions),
           (tableView.reloadRows, modifications)].forEach(self.perform)
        }, completion: nil)
      case .error(let error):
        // An error occurred while opening the Realm file on the background worker thread
        fatalError("\(error)")
      }
    }
  }

  private func perform(update: ([IndexPath], UITableView.RowAnimation) -> Void, forIndexes indexes: [Int]) {
    if indexes.isEmpty { return }
    let indexPaths = indexes.map { IndexPath(row: $0, section: 0) }
    update(indexPaths, .automatic)
  }
}

// MARK: - DependencyContaining

extension NearbyDroppsViewController: DependencyContaining {
  func resolveDepedencies() {
    droppProvider = container.resolve(DroppProvider.self)
    realmProvider = container.resolve(RealmProvider.self)
  }
}

// MARK: - NearbyDroppCellDelegate

extension NearbyDroppsViewController: NearbyDroppCellDelegate {
  func nearbyDroppTableViewCell(shouldShowUserFromCell nearbyDroppTableViewCell: NearbyDroppTableViewCell) {
    performSegue(withIdentifier: Constants.showUserSegue, sender: nearbyDroppTableViewCell)
  }
}
