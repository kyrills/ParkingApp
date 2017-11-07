import Foundation
import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            self.locationmanager.requestLocation()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

//        if let location = locations.last {
//            //function getParkingData does not yet take parameters
////            ParkingAmsterdamService.sharedInstance.getParkingData(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            self.locationmanager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }

}
