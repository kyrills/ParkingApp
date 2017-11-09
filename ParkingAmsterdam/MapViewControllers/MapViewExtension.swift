import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        
        parkingMapView.showsCompass =  true
        parkingMapView.showsTraffic = true
        parkingMapView.showsBuildings = true
        parkingMapView.showsPointsOfInterest = true
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let reuseId = "pin"
        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView else { return nil }
        
        pinView.pinTintColor = UIColor.orange
        pinView.canShowCallout = true
        
        return pinView
        }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
////        let circleRenderer = MKCircleRenderer(overlay: overlay)
////        circleRenderer.strokeColor = UIColor.blue
////        circleRenderer.fillColor = UIColor(
////            red: 0,
////            green: 0,
////            blue: 1.0,
////            alpha: 0.3)
//
//        return nil
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

    }

}
