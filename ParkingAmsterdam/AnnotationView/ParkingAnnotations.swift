import Foundation
import MapKit

class ParkingAnnotations: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var parkingGarage: ParkingObjects

    init(parkingGarage: ParkingObjects, coordinate: CLLocationCoordinate2D) {
        self.parkingGarage = parkingGarage
        self.coordinate = coordinate
        super.init()
        
    }
    var title: String?{
        return parkingGarage.Name.removeFirstCharacters()
    }
    
    var subtitle: String?{
        return "\(parkingGarage.FreeSpaceShort)"
    }
}


