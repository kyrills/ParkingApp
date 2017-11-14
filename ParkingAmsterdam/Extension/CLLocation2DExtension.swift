import CoreLocation
import MapKit
extension CLLocationCoordinate2D {
    func convertToAddress(onCompletion: @escaping (String)->Void) {
        
        let locationToConvert = CLLocation(latitude: self.latitude, longitude: self.longitude)
        var addressString = ""

        CLGeocoder().reverseGeocodeLocation(locationToConvert) { (placemark, error) in
            if error != nil {
                print ("THERE WAS AN ERROR")
            } else {
                if let address = placemark?[0] {
                    let mkplace = MKPlacemark.init(placemark: address)
                    addressString = mkplace.parseAddress()
                }
                onCompletion(addressString)
            }
        }
    }
}
