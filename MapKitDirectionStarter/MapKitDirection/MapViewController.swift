//
//  MapViewController.swift
//  MapKitDirection
//
//  Created by Simon Ng on 6/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var currentPlacemark: CLPlacemark?
    
    var restaurant:Restaurant!
    let locationManager = CLLocationManager()
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        showPin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupMap() {
        mapView.delegate = self
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
        mapView.showsUserLocation = true
        
        // Request for a user's authorization for location services
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        segmentedControl.isHidden = true
    }
    
    private func showPin() {
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
    }
    
    @IBAction func showDirection(_ sender: Any) {
        guard let currentPlacemark = currentPlacemark else { return }
        segmentedControl.isHidden = false
        let directionRequest = MKDirections.Request()
        
        // Set the source and destination of the route
        directionRequest.source = .forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (routeResponse, routeError) in
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                return
            }
            // Clear the map
            self.mapView.removeOverlays(self.mapView.overlays)
            
            // Draw new route
            let route = routeResponse.routes[0]
            self.currentRoute = route
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    @IBAction func changeTransportType(_ sender: Any) {
        if currentTransportType == .automobile {
            currentTransportType = .walking
        } else {
            currentTransportType = .automobile
        }
        showDirection(self)
    }
    
    @IBAction func showNearby(sender: UIButton) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = restaurant.type
        searchRequest.region = mapView.region
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            let mapItems = response.mapItems
            var nearbyAnnotations: [MKAnnotation] = []
            if mapItems.count > 0 {
                for item in mapItems {
            
                    // Add annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    if let location = item.placemark.location {
                        annotation.coordinate = location.coordinate
                    }
                    nearbyAnnotations.append(annotation)
                }
            }
            
            self.mapView.showAnnotations(nearbyAnnotations, animated: true)

        }

    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identiﬁer = "MyPin"
        if annotation.isKind(of: MKUserLocation.self) { return nil }

        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identiﬁer) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identiﬁer)
            annotationView?.canShowCallout = true
        }
        
        // Pin color customization based on the type of annotation
        if let currentPlacemarkCoordinate = currentPlacemark?.location?.coordinate {
            if currentPlacemarkCoordinate.latitude == annotation.coordinate.latitude && currentPlacemarkCoordinate.longitude == annotation.coordinate.longitude {
                let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
                leftIconView.image = UIImage(named: restaurant.image)
                annotationView?.leftCalloutAccessoryView = leftIconView
                
                // Pin color customization
                if #available(iOS 9.0, *) {
                    annotationView?.pinTintColor = .orange
                }
                
                // should be used only for current placemark otherwise user could see route steps from location to current restaurant from nearby restaurants
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                
                // Pin color customization
                if #available(iOS 9.0, *) {
                    annotationView?.pinTintColor = .red
                }
            }
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = currentTransportType == .automobile ? .blue : .orange
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let routeVC = mainStoryboard.instantiateViewController(withIdentifier: "Steps")
        routeVC.modalPresentationStyle = .fullScreen
        if let steps = currentRoute?.steps {
            (routeVC.children[0] as! RouteTableViewController).routeSteps = steps
        }
        present(routeVC, animated: true, completion: nil)
    }
}
