import UIKit
import MapKit
import CoreLocation
import Foundation

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MapViewController: UIViewController, GarageDetailMapViewDelegate {
    
    @IBOutlet weak var parkingMapView: MKMapView!
    
    var locationmanager = CLLocationManager()
    let regionRadius: CLLocationDistance = 12000
    
    var destinationCoordinate = CLLocationCoordinate2D()
    var sourceCoordinate = CLLocationCoordinate2D()
    
    let request = MKDirectionsRequest()
    
    var parkingGarages: [ParkingObjects] = []
    var selectedGarage : ParkingObjects?
    
    var resultSearchController: UISearchController!
    
    var droppedPin: MKPinAnnotationView?
    var selectedPin: MKPlacemark?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParkingAmsterdamService.sharedInstance.getParkingData()
        
//  ToDo Fix timer stuff
//        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(getParkingData) , userInfo: nil, repeats: true)
        
        self.locationmanager.delegate = self
        self.locationmanager.requestWhenInUseAuthorization()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        
        navigationItem.titleView = resultSearchController?.searchBar
        
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
    }
    
    @objc func getParkingData() {
        ParkingAmsterdamService.sharedInstance.getParkingData()
    }
    
    func setZoomInitialLocation(location: CLLocationCoordinate2D){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 0.2,
                                                                  regionRadius * 0.2)
        parkingMapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func setInitialData(notification: NSNotification){
        var parkingDict = notification.userInfo as! Dictionary<String, [ParkingObjects]>
        parkingGarages = parkingDict["data"]!
        
        guard self.parkingMapView.annotations.count == 0 else{
            return
        }
        
        var annotationObject: [ParkingAnnotations] = []
        
        for garage in parkingGarages{
            let coordinate = CLLocationCoordinate2D.init(latitude: garage.latitude, longitude: garage.longitude)
            let annotation = ParkingAnnotations.init(parkingGarage: garage, coordinate: coordinate)
            
            annotationObject.append(annotation)
        }
        self.parkingMapView.showAnnotations(annotationObject, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gdvc = segue.destination as? GarageDetailViewController {
            gdvc.selectedGarage = self.selectedGarage
        }
    }
    
    func detailsRequested(for parkingGarages: ParkingObjects) {
        self.selectedGarage = parkingGarages
        self.performSegue(withIdentifier: "goToDetailView", sender: nil)
    }
    
    func routeToRequested(for parkingGarages: ParkingObjects) {
        destinationCoordinate.latitude = parkingGarages.latitude
        destinationCoordinate.longitude = parkingGarages.longitude
        coordinatesToMapViewRepresentation()
    }
}


