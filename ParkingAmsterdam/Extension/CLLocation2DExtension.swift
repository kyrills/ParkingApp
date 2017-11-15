import CoreLocation
import MapKit
extension CLLocationCoordinate2D {
    func convertToAddress(onCompletion: @escaping (String)->Void) {
        
        let locationToConvert = CLLocation(latitude: self.latitude, longitude: self.longitude)
        var addressString = ""

        CLGeocoder().reverseGeocodeLocation(locationToConvert) { (placemark, error) in
            if error != nil {
                print ("THERE WAS AN ERROR", error?.localizedDescription)
            } else {
                if let address = placemark?[0] {
                    let mkplace = MKPlacemark.init(placemark: address)
                    addressString = mkplace.parseAddress()
                }
                onCompletion(addressString)
            }
        }
    }
    
    func calculateDistance(destination: CLLocationCoordinate2D) -> CLLocationDistance{
        let coordinateSource = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let coordinateDestination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distanceInMeters = coordinateSource.distance(from: coordinateDestination)
        return ((distanceInMeters)/100).rounded()
    }
}
