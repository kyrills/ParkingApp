import Foundation
import CoreLocation
import MapKit
import UIKit

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            self.locationmanager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationmanager.stopUpdatingLocation()
        if let coord = locations.first {
            sourceCoordinate.latitude = coord.coordinate.latitude
            sourceCoordinate.longitude = coord.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}
