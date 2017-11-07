//
//  ViewController.swift
//  ParkingAmsterdam
//
//  Created by Kyrill van Seventer on 06/11/2017.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var parkingMapView: MKMapView!
    
    var locationmanager = CLLocationManager()
    let regionRadius: CLLocationDistance = 12000
    


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationmanager.delegate = self
        self.locationmanager.requestWhenInUseAuthorization()
        
        parkingMapView.showsUserLocation = true
        parkingMapView.delegate = self
        
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.setInitialData(notification:)),
                                               name: NSNotification.Name(rawValue: NotificationID.setInitialData),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setZoomInitialLocation(location: CLLocationCoordinate2D){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        parkingMapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func setInitialData(notification: NSNotification){
        
//        var parkingDict = notification.userInfo as! Dictionary<String, []>
//
//        var annotations: [ParkingAnnotations] = []
        
        
    }

    @IBAction func locationButton(_ sender: Any) {
        parkingMapView.setCenter((parkingMapView.userLocation.location?.coordinate)!, animated: true)
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
    }
}

