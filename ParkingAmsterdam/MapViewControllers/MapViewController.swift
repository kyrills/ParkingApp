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
    
    var searchAnnotationArray: [MKPointAnnotation] = []
    
    let request = MKDirectionsRequest()
    
    var parkingGaragesAdam: [ParkingObjects] = []
    var parkingGaragesRdam: [ParkingObjects] = []
    
    var selectedGarage: ParkingObjects?
    
    var resultSearchController: UISearchController!
    
    var droppedPin: MKPinAnnotationView?
    var selectedPin: MKPlacemark?
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParkingAmsterdamService.sharedInstance.getParkingData()
        ParkingRotterdamService.sharedInstance.getData()
        
        //  ToDo Fix timer stuff
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(getParkingData) , userInfo: nil, repeats: true)
        
        self.locationmanager.delegate = self
        self.locationmanager.requestWhenInUseAuthorization()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        resultSearchController.searchBar.barTintColor = UIColor.darkGray
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        
        UINavigationBar.appearance().barTintColor = .lightGray
        UINavigationBar.appearance().tintColor = .lightGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        UINavigationBar.appearance().isTranslucent = false
        
        navigationItem.titleView = resultSearchController?.searchBar
        navigationItem.titleView?.backgroundColor = UIColor.darkGray
        definesPresentationContext = true
        
        locationSearchTable.mapView = parkingMapView
        locationSearchTable.handleMapSearchDelegate = self
        
        parkingMapView.showsUserLocation = true
        parkingMapView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.setInitialData(notification:)),
                                               name: NSNotification.Name(rawValue: NotificationID.setInitialData),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.setSecondData(notification:)),
                                               name: NSNotification.Name(rawValue: NotificationID.setSecondData),
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

// plz explain the notification func a bit again, cant find it on the internet
@objc func setSecondData(notification: NSNotification) {
    var secondData = notification.userInfo as! Dictionary<String, [ParkingObjects]>
    if let parkingRotterdam = secondData["data2"]{
        parkingGaragesRdam += parkingRotterdam
    }
    var annotationObject: [ParkingAnnotations] = []
    
    for garage in parkingGaragesRdam{
        let coordinate = CLLocationCoordinate2D.init(latitude: Double(garage.latitude!)!,
                                                     longitude: Double(garage.longitude!)!)
        let annotation = ParkingAnnotations.init(parkingGarage: garage, coordinate: coordinate)
        
        annotationObject.append(annotation)
    }
    self.parkingMapView.showAnnotations(annotationObject, animated: true)
}
    
    
    @objc func setInitialData(notification: NSNotification){
        //this ensures map is only loaded once, after that the data must be requested from REALM
        guard self.parkingGaragesAdam.count == 0 else {
            return
        }
        
        var parkingDict = notification.userInfo as! Dictionary<String, [ParkingObjects]>
        parkingGaragesAdam = parkingDict["data"]!
        
        
        var annotationObject: [ParkingAnnotations] = []
        
        for garage in parkingGaragesAdam{
            let coordinate = CLLocationCoordinate2D.init(latitude: Double(garage.latitude!)!,
                                                         longitude: Double(garage.longitude!)!)
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
        
        if let lat = Double(parkingGarages.latitude!),
            let lng = Double(parkingGarages.longitude!) {
            destinationCoordinate.latitude = lat
            destinationCoordinate.longitude = lng
            
        }
        
        coordinatesToMapViewRepresentation()
        parkingMapView.removeOverlays(parkingMapView.overlays)
    }
    
    
    
}
