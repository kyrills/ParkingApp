import UIKit
import MapKit

class ParkingList: UITableViewController {
    
    var parkingGarages: [ParkingObjects] = []
    var selectedGarage: ParkingObjects!
    var addressLocation = CLLocationCoordinate2D()
    var sourceCoordinate = CLLocationCoordinate2D()
    
    @IBOutlet weak var favouriteButton: UIButton!
    var rightButtonItem: UIBarButtonItem?
    var favouriteState : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parkingListNib = UINib(nibName: "parkListCell", bundle: nil)
        setFavourite()
        self.tableView.register(parkingListNib, forCellReuseIdentifier: cellID.parkListCell)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateDistancesForGarages()
        parkingGarages = ParkingObjects.sortByDistance()
        self.tableView.reloadData()
        
        
    }
    
    @IBAction func toggleFavourite(_ sender: UIButton) {
        if favouriteState == false {
            favouriteState = favouriteState == false ? true : false
            favouriteButton.setImage(favouriteState == true ? #imageLiteral(resourceName: "starYellowBig") : #imageLiteral(resourceName: "starWhiteBig"), for: UIControlState.normal)
            parkingGarages = ParkingObjects.sortedByFavourite()
        } else{
            favouriteState = favouriteState == false ? true : false
            favouriteButton.setImage(favouriteState == true ? #imageLiteral(resourceName: "starYellowBig") : #imageLiteral(resourceName: "starWhiteBig"), for: UIControlState.normal)
            updateDistancesForGarages()
            parkingGarages = ParkingObjects.sortByDistance()
        }
        self.tableView.reloadData()
    }
    
    func setFavourite() {
        
        let rightButtonItem = UIBarButtonItem.init(customView: favouriteButton)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func updateDistancesForGarages() {
        parkingGarages = ParkingObjects.retrieveAllData()
        for garage in parkingGarages {
            getDistancesFromCurrentLocation(storeObject: garage)
        }
    }
    
    func getDistancesFromCurrentLocation(storeObject: ParkingObjects) {
        if let lat = Double(storeObject.latitude!),
            let lng = Double(storeObject.longitude!) {
            
            let dist = sourceCoordinate.calculateDistance(destination: CLLocationCoordinate2D.init(latitude: lat,longitude: lng))
            storeObject.saveDistance(distance: "\(dist)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parkingGarages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.parkListCell, for: indexPath) as! ParkListCell
        
        let storeObject = parkingGarages[indexPath.row]
        
        cell.addressLabel.text = storeObject.address
        
        cell.distanceKMLabel.text = "\(storeObject.distanceInMeters) km"
        
        cell.parkingGarageNameLabel.text = storeObject.Name
      
        if storeObject.FreeSpaceLong == "" {
            cell.freeSpacesLabel.text = "0 Free"
        } else {
            cell.freeSpacesLabel.text = "\(storeObject.FreeSpaceShort ?? "0") Free"
        }
        
        return cell
        
    }
}
