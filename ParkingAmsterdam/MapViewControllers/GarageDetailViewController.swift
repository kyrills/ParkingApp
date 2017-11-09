//
//  GarageDetailViewController.swift
//  ParkingAmsterdam
//
//  Created by Michiel Everts on 08-11-17.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import Foundation
import UIKit

class GarageDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var garageImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var backButton: UIButton!
    
    var parkingGarages: [ParkingObjects] = []
    var selectedGarage: ParkingObjects!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "detailTableViewCell", bundle: nil), forCellReuseIdentifier: "detailTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
//
//    @IBAction func goBack(_ sender: Any) {
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingGarages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailTableViewCell", for: indexPath) as! detailTableViewCell
        
        return cell
    }
    
}

