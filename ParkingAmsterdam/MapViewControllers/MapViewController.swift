import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var parkingMapView: MKMapView!
    
    var locationmanager = CLLocationManager()
    let regionRadius: CLLocationDistance = 12000
    var parkingGarages: [ParkingObjects] = []
    var destinationCoordinate = CLLocationCoordinate2D()
    var sourceCoordinate = CLLocationCoordinate2D()
    
   
    
    var selectedGarage : ParkingObjects?
    let request = MKDirectionsRequest()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParkingAmsterdamService.sharedInstance.getParkingData()
        self.locationmanager.delegate = self
        self.locationmanager.requestWhenInUseAuthorization()
        
        parkingMapView.showsUserLocation = true
        parkingMapView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.setInitialData(notification:)),
                                               name: NSNotification.Name(rawValue: NotificationID.setInitialData),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setZoomInitialLocation(location: CLLocationCoordinate2D){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 0.2,
                                                                  regionRadius * 0.2)
        parkingMapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func setInitialData(notification: NSNotification){
        
        var parkingDict = notification.userInfo as! Dictionary<String, [ParkingObjects]>
        parkingGarages = parkingDict["data"]!
        var annotationObject: [ParkingAnnotations] = []
        
        for garage in parkingGarages{
            let coordinate = CLLocationCoordinate2D.init(latitude: garage.latitude, longitude: garage.longitude)
            let annotation = ParkingAnnotations.init(parkingGarage: garage, coordinate: coordinate)
            
            annotation.title = garage.Name.removeFirstCharacters()
            annotationObject.append(annotation)
        }
        self.parkingMapView.showAnnotations(annotationObject, animated: true)
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func locationButton(_ sender: Any) {
        parkingMapView.setCenter((parkingMapView.userLocation.location?.coordinate)!, animated: true)
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Hier schrijf je wat moet geproberen als er op "i" geklikt wordt
        
        if let mapAannotation = view.annotation as? ParkingAnnotations {
            destinationCoordinate.latitude = mapAannotation.coordinate.latitude
            destinationCoordinate.longitude = mapAannotation.coordinate.longitude
            coordinatesToMapViewRepresentation()
        }
    }
}

