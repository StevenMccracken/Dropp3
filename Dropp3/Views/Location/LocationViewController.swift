//
//  LocationViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/29/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

  // MARK: - Location

  var location: Location!

  private var coordinate: CLLocationCoordinate2D {
    return location.coreLocation.coordinate
  }

  private var annotation: MKAnnotation {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    return annotation
  }

  private var region: MKCoordinateRegion {
    let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    return MKCoordinateRegion(center: coordinate, span: span)
  }

  // MARK: - Views

  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var coordinatesButton: UIBarButtonItem!
  @IBOutlet private weak var currentLocationButton: UIBarButtonItem!

}

// MARK: - View lifecycle

extension LocationViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setToolbarHidden(true, animated: true)
  }
}

// MARK: - View configuration

private extension LocationViewController {
  func configureViews() {
    configureNavigation()
    configureMapView()
  }

  func configureNavigation() {
    navigationItem.backBarButtonItem?.title = nil
    navigationController?.setToolbarHidden(false, animated: false)
  }

  func configureMapView() {
    mapView.addAnnotation(annotation)
    mapView.setUserTrackingMode(.followWithHeading, animated: true)
    mapView.setRegion(region, animated: true)
  }
}
