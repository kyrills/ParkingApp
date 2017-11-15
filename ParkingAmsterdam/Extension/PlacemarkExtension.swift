import Foundation
import MapKit
extension MKPlacemark {
    
    func parseAddress() -> String {
        
        let firstSpace = (self.subThoroughfare != nil &&
            self.thoroughfare != nil) ? " " : ""
        
        let comma = (self.subThoroughfare != nil || self.thoroughfare != nil) &&
            (self.subAdministrativeArea != nil || self.administrativeArea != nil) ? ", " : ""
        
        let secondSpace = (self.subAdministrativeArea != nil &&
            self.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            self.subThoroughfare ?? "",
            firstSpace,
            // street name
            self.thoroughfare ?? "",
            comma,
            // city®
            self.locality ?? "",
            secondSpace,
            // state
            self.administrativeArea ?? ""
        )
        
        return addressLine
    }
}
