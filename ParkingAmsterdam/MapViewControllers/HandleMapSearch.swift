import MapKit
import UIKit

extension MapViewController: HandleMapSearch{
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        selectedPin = placemark
        parkingMapView.removeAnnotations(searchAnnotationArray)
        let searchAnnotation = MKPointAnnotation()
                
        searchAnnotation.coordinate = placemark.coordinate
        searchAnnotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            searchAnnotation.subtitle = "\(city) \(state)"
        }
        
        parkingMapView.addAnnotation(searchAnnotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        parkingMapView.setRegion(region, animated: true)
//        searchAnnotationArray.append(searchAnnotation)
    }
}
