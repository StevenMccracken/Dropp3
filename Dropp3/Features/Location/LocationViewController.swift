//
//  LocationViewController.swift
//  Dropp3
//
//  Created by Steven McCracken on 1/29/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import UIKit
import MapKit

private enum CoordinateSpanDelta: CLLocationDegrees {
  case standard = 5
}

final class LocationViewController: UIViewController {
  // MARK: - Location

  var location: Location!
  private var coordinate: CLLocationCoordinate2D { location.coreLocation.coordinate }
  private var annotation: MKAnnotation {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    return annotation
  }
  private var region: MKCoordinateRegion {
    let span = MKCoordinateSpan(latitudeDelta: CoordinateSpanDelta.standard.rawValue,
                                longitudeDelta: CoordinateSpanDelta.standard.rawValue)
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
}

// MARK: - View configuration

private extension LocationViewController {
  func configureViews() {
    configureMapView()
  }

  func configureMapView() {
    mapView.addAnnotation(annotation)
    mapView.setUserTrackingMode(.followWithHeading, animated: true)
    mapView.setRegion(region, animated: true)
  }
}
