//
//  TableViewController.swift
//  ParkingAmsterdam
//
//  Created by Trym Lintzen on 13-11-17.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import UIKit
import MapKit

class ParkingList: UITableViewController {

    var parkingGarages: [ParkingObjects] = []
    var selectedGarage: ParkingObjects!
    var addressLocation = CLLocationCoordinate2D()
    var sourceCoordinate = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        let parkingListNib = UINib(nibName: "parkListCell", bundle: nil)
        self.tableView.register(parkingListNib, forCellReuseIdentifier: cellID.parkListCell)
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateDistancesForGarages()
        parkingGarages = ParkingObjects.sortByDistance()
        self.tableView.reloadData()

        
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

    
    
    @IBAction func sortingList(_ sender: Any) {
        let selectedSegment = (sender as AnyObject).selectedIndex
        
        if selectedSegment == 0 {
            // Trym's code : distance
            
        } else {
            // Kyrill's code (favourite)
            selectedGarage.favouriteParkingSpot()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
