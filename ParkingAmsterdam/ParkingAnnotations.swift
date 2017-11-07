import Foundation
import MapKit

class ParkingAnnotations: NSObject, MKAnnotation{
    var parkingGarage: ParkingObjects
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(parkingGarage: ParkingObjects, coordinate: CLLocationCoordinate2D) {
        self.parkingGarage = parkingGarage
        self.coordinate = coordinate
    }
}

