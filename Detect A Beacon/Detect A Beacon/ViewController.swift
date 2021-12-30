//
//  ViewController.swift
//  Detect A Beacon
//
//  Created by Phat Nguyen on 29/12/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        initialLocationManager()
    }

    /**
        1. If you request Always access, users will still get the chance to choose When In Use.
        2. If they choose Always, iOS will automatically ask them again after a few days to confirm they still want to grant Always access.
        3. When your app is using location data in the background the iOS UI will update to reflect that – users will know it’s happening.
        4. Users can, at any point, go into the settings app and change from Always down to When In Use.
    */
    
    func initialLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    // UUID: You're in a Acme Hardware Supplies store.
    // Major: You're in the Glasgow branch.
    // Minor: You're in the shoe department on the third floor.
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beacon = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beacon)
        locationManager?.startRangingBeacons(satisfying: beacon.beaconIdentityConstraint)
    }
    
    func update(distance: CLProximity) {
        // Chage View
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            default:
                self.view.backgroundColor = .black
                self.distanceReading.text = "WHOA!"
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    /// isMonitoringAvailable: Returns a Boolean value indicating whether the device supports region monitoring using the specified class.
    /// isRangingAvailable: Returns a Boolean value indicating whether the device supports ranging of beacons that use the iBeacon protocol.
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}
