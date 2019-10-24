//
//  ViewController.swift
//  Places_Aniversarie
//
//  Created by Bassuni on 10/23/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import UIKit
import MapKit
class MapVC: UIViewController , MKMapViewDelegate {
     var locationCoordinate : CLLocationCoordinate2D? = nil
       @IBOutlet var mapView: MKMapView!
      override func viewDidLoad() {
          super.viewDidLoad()
          self.mapView.delegate = self;
          guard (self.locationCoordinate != nil)
              else { return }
          let annotation = MKPointAnnotation()
          annotation.coordinate = CLLocationCoordinate2D(latitude: (self.locationCoordinate?.latitude)!, longitude: (self.locationCoordinate?.longitude)!)
          mapView.addAnnotation(annotation)
          let region = MKCoordinateRegion(center:  (annotation.coordinate), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
          self.mapView.setRegion(region, animated: true)
      }
}

