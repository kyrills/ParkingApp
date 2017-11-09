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
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    /// Process coordinates and requests stuff
    ///
    /// - Returns: MKDirection request
    private func getDirections() -> MKDirections {
        
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.sourceCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.destinationCoordinate, addressDictionary: nil))
        
        print(sourceCoordinate)
        print(destinationCoordinate)
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        return MKDirections(request: request)
    }
    
    
    
    func coordinatesToMapViewRepresentation() {
        
        let directions = getDirections()
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.parkingMapView.add(route.polyline)
                
                var regionRect = route.polyline.boundingMapRect
                
                let wPadding = regionRect.size.width * 0.25
                let hPadding = regionRect.size.height * 0.25
                
                //Add padding to the region
                regionRect.size.width += wPadding
                regionRect.size.height += hPadding
                
                //Center the region on the line
                regionRect.origin.x -= wPadding / 2
                regionRect.origin.y -= hPadding / 2
                
                self.parkingMapView.setRegion(MKCoordinateRegionForMapRect(regionRect), animated: false)
                
            }
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
    }
}
