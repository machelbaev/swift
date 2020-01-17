//
//  TrackViewController.swift
//  Showcase
//
//  Created by Mikhail on 14.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit
import CoreLocation

class TrackViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    
    let locationText: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        tv.isEditable = false
        tv.layer.cornerRadius = 5.0
        return tv
    }()
    
    lazy var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(changeToggle), for: .touchUpInside)
        return toggle
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        setUpElements()
    }

    fileprivate func setUpElements() {
        view.addSubview(locationText)
        locationText.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 150))
        
        view.addSubview(toggleSwitch)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.topAnchor.constraint(equalTo: locationText.bottomAnchor, constant: 10).isActive = true
        toggleSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func changeToggle() {
        if toggleSwitch.isOn {
            
            if (CLLocationManager.locationServicesEnabled() == false) {
                self.toggleSwitch.isOn = false
            }
            
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.distanceFilter = 10.0
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.startUpdatingLocation()
            
        } else {
            if locationManager != nil {
                locationManager.stopUpdatingLocation()
            }
        }
    }

}

extension TrackViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.endIndex-1]
        self.locationText.text = "Coordinate: \(String(format: "%.5f", location.coordinate.latitude)), \(String(format: "%.5f", location.coordinate.longitude))\nSpeed: \(location.speed)\nTime: \(location.timestamp)"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationText.text = "Failed with error \(error.localizedDescription) "
    }
    
}

