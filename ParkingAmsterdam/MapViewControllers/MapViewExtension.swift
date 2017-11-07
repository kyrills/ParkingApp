//
//  MapViewExtension.swift
//  ParkingAmsterdam
//
//  Created by Kyrill van Seventer on 07/11/2017.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
       return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let tempReturn = MKCircleRenderer(overlay: overlay)
        
        return tempReturn
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

    }
}
