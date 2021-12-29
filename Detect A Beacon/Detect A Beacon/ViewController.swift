//
//  ViewController.swift
//  Detect A Beacon
//
//  Created by Phat Nguyen on 29/12/2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
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
    
    
}

