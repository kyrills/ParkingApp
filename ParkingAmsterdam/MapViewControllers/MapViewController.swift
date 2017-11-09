import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var parkingMapView: MKMapView!
    
    var locationmanager = CLLocationManager()
    let regionRadius: CLLocationDistance = 12000
    
    var parkingGarages: [ParkingObjects] = []
    
    var searchAnnotationArray: [MKPointAnnotation] = []
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParkingAmsterdamService.sharedInstance.getParkingData()
        self.locationmanager.delegate = self
        self.locationmanager.requestWhenInUseAuthorization()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = parkingMapView
        locationSearchTable.handleMapSearchDelegate = self
        
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

            setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
        }
        self.parkingMapView.showAnnotations(annotationObject, animated: true)
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
    }
    
    @IBAction func locationButton(_ sender: Any) {
        parkingMapView.setCenter((parkingMapView.userLocation.location?.coordinate)!, animated: true)
        setZoomInitialLocation(location: parkingMapView.userLocation.coordinate)
    }
    
}


