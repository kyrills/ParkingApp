//
//  detailTableViewCell.swift
//  ParkingAmsterdam
//
//  Created by Michiel Everts on 08-11-17.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.


import UIKit

class detailTableViewCell: UITableViewCell {
    @IBOutlet weak var TableViewLabel: UILabel!

    var garage: String!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWithItem(garage: String) {
        self.garage = garage
        self.TableViewLabel?.text = garage
    }

}

