import MapKit
import UIKit

extension MapViewController: HandleMapSearch{
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        selectedPin = placemark

        if let droppedPinAnnotation = droppedPin?.annotation {
            parkingMapView.removeAnnotation(droppedPinAnnotation)
        }
        
        let pointAnnotation = MKPointAnnotation.init()
        pointAnnotation.coordinate = placemark.coordinate
        pointAnnotation.title = placemark.name
        
        droppedPin = MKPinAnnotationView.init(annotation: pointAnnotation, reuseIdentifier: "droppedPin")
        droppedPin?.canShowCallout = true
        droppedPin?.animatesDrop = true
        self.parkingMapView.selectAnnotation((droppedPin?.annotation)!, animated: true)

        if let droppedAnnotation = droppedPin?.annotation {
            parkingMapView.addAnnotation(droppedAnnotation)
        }
        self.parkingMapView.selectAnnotation((self.droppedPin?.annotation)!, animated: true)

        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        parkingMapView.setRegion(region, animated: true)
        setZoomInitialLocation(location: placemark.coordinate)
    }
}
