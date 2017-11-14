//
//  ParkListCell.swift
//  ParkingAmsterdam
//
//  Created by Trym Lintzen on 14-11-17.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import UIKit

class ParkListCell: UITableViewCell {

    @IBOutlet weak var parkingGarageNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var freeSpacesLabel: UILabel!
    @IBOutlet weak var distanceKMLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        parkingGarageNameLabel.text = ""
        addressLabel.text = ""
        freeSpacesLabel.text = ""
        distanceKMLabel.text = ""
    }
    
}
