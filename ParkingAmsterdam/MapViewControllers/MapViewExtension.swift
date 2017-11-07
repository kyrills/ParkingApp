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
        if annotation is MKUserLocation {
            return nil
        }
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin"){
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView.pinTintColor = UIColor.magenta
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            return pinView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.fillColor = UIColor(
            red: 0,
            green: 0,
            blue: 1.0,
            alpha: 0.3)
        
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
    }
}
