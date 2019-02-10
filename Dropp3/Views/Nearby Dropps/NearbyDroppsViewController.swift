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
}

class NearbyDroppsViewController: UIViewController, ContainerConsumer {
  private lazy var viewModel: NearbyDroppsViewModelProtocol = {
    var viewModel = container.resolve(NearbyDroppsViewModelProtocol.self)!
    viewModel.delegate = self
    return viewModel
  }()

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
}

// MARK: - View lifecycle

extension NearbyDroppsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    viewModel.viewDidLoad()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if segue.identifier == Constants.showUserSegue {
      guard let destination = segue.destination as? UserViewController,
        let cell = sender as? NearbyDroppTableViewCell,
        let indexPath = tableView.indexPath(for: cell) else { fatalError() }

      destination.user = viewModel.dropps[indexPath.row].user!
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
    return viewModel.dropps.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? NearbyDroppTableViewCell else { fatalError() }
    cell.delegate = self
    cell.provide(dropp: viewModel.dropps[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let title = viewModel.title(forEditActionAtRow: indexPath.row)
    let hideAction = UITableViewRowAction(style: .normal, title: title) { [weak self] (_, indexPath) in
      self?.viewModel.shouldPerformEditAction(atRow: indexPath.row)
    }

    hideAction.backgroundColor = .buttonBackground
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
    viewModel.shouldRefreshData()
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

// MARK: - NearbyDroppCellDelegate

extension NearbyDroppsViewController: NearbyDroppCellDelegate {
  func nearbyDroppTableViewCell(shouldShowUserFromCell nearbyDroppTableViewCell: NearbyDroppTableViewCell) {
    performSegue(withIdentifier: Constants.showUserSegue, sender: nearbyDroppTableViewCell)
  }
}

extension NearbyDroppsViewController: NearbyDroppsViewModelDelegate {
  func reloadData() {
    tableView.reloadData()
  }

  func updateData(deletions: [Int], insertions: [Int], modifications: [Int]) {
    tableView.update(deletions: deletions, insertions: insertions, modifications: modifications)
  }
}
