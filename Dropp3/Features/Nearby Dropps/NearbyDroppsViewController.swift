//
//  NearbyDroppsViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/20/19.
//

import UIKit
import MapKit
import RealmSwift

// MARK: - Constants

private enum Duration {
  enum TableViewFade: TimeInterval {
    case alpha = 0.5
    case hidden = 0.15
  }
}

// MARK: - NearbyDroppsViewController

final class NearbyDroppsViewController: UIViewController, ContainerConsumer {
  private static let cellID = UUID().uuidString
  private lazy var viewModel: NearbyDroppsViewModelProtocol = {
    var viewModel = container.resolve(NearbyDroppsViewModelProtocol.self)!
    viewModel.delegate = self
    return viewModel
  }()

  // MARK: - State

  private var showsListView: Bool {
    get { !tableView.isHidden }
    set {
      let generator = UIImpactFeedbackGenerator(style: .light)
      generator.prepare()
      UIView.transition(with: tableView,
                        duration: Duration.TableViewFade.hidden.rawValue,
                        options: .transitionCrossDissolve,
                        animations: { [weak self] in
                          self?.tableView.isHidden = !newValue
                          self?.listButton.isEnabled = !newValue
      })

      UIView.animate(withDuration: Duration.TableViewFade.alpha.rawValue) { [weak self] in
        self?.tableView.alpha = newValue ? 1 : 0
      }

      generator.impactOccurred()
    }
  }

  // MARK: - Subviews

  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var listButton: UIBarButtonItem!
  @IBOutlet private weak var locateButton: UIBarButtonItem!
  @IBOutlet private weak var refreshButton: UIBarButtonItem!

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
    viewModel.shouldRefreshData()
  }
}

// MARK: - View configuration

private extension NearbyDroppsViewController {
  func configureViews() {
    configureMapView()
    configureTableView()
  }

  func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(NearbyDroppTableViewCell.nib, forCellReuseIdentifier: NearbyDroppsViewController.cellID)
  }

  func configureMapView() {
    mapView.delegate = self
    [panGestureRecognizer, doubleTapGestureRecognizer, pinchGestureRecognizer].forEach(mapView.addGestureRecognizer)
  }
}

// MARK: - UITableViewDataSource

extension NearbyDroppsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.dropps.count }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NearbyDroppsViewController.cellID,
                                                   for: indexPath) as? NearbyDroppTableViewCell else {
                                                    fatalError("Invalid reusable cell for index path: \(indexPath)")
    }
    cell.delegate = self
    cell.provide(dropp: viewModel.dropps[indexPath.row])
    return cell
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

// MARK: - Actions

private extension NearbyDroppsViewController {
  @IBAction func listButtonAction(_ sender: UIBarButtonItem) {
    showsListView = true
  }

  @IBAction func refreshAction(_ sender: UIBarButtonItem) {
    viewModel.shouldRefreshData()
  }

  @IBAction func locateAction(_ sender: UIBarButtonItem) {
    debugPrint("locate")
  }

  @objc
  func mapUserInteractionAction(_ gestureRecognizer: UIGestureRecognizer) {
    if gestureRecognizer.state == .began, showsListView {
      showsListView = false
    }
  }
}

// MARK: - UIGestureRecognizerDelegate

extension NearbyDroppsViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { true }
}

// MARK: - NearbyDroppCellDelegate

extension NearbyDroppsViewController: NearbyDroppCellDelegate {
  func nearbyDroppTableViewCell(shouldShowUserFromCell nearbyDroppTableViewCell: NearbyDroppTableViewCell) {
    guard let indexPath = tableView.indexPath(for: nearbyDroppTableViewCell) else {
      debugPrint("Unable to find matching index path for given cell")
      return
    }
    let userViewController = viewModel.controller(forRow: indexPath.row)
    navigationController?.pushViewController(userViewController, animated: true)
  }
}

// MARK: - NearbyDroppsViewModelDelegate

extension NearbyDroppsViewController: NearbyDroppsViewModelDelegate {
  func reloadData() {
    tableView.reloadData()
  }

  func updateData(deletions: [Int], insertions: [Int], modifications: [Int]) {
    tableView.update(deletions: deletions, insertions: insertions, modifications: modifications)
  }
}
