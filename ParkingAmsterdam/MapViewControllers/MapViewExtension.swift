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
        if annotation is MKUserLocation { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapPin")
        
        if annotationView == nil {
            annotationView = DetailAnnotationView(annotation: annotation, reuseIdentifier: "mapPin")
            (annotationView as! DetailAnnotationView).delegate = self
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
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
