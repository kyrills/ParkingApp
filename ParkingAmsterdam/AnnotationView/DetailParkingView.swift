//
//  DetailParkingView.swift
//  ParkingAmsterdam
//
//  Created by Michiel Everts on 08-11-17.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import Foundation
import UIKit

protocol GarageDetailMapViewDelegate: class {
    func detailsRequested(for parkingGarages: ParkingObjects)
}

class DetailParkingView: UIView {
    // outlets
    @IBOutlet weak var goToDetailButton: UIButton!
    @IBOutlet weak var routeToGarageButton: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var parkingSpaceLabel: UILabel!
    @IBOutlet weak var backgroundContentButton: UIButton!
    
    // data
    var parkingGarages: ParkingObjects!
    weak var delegate: GarageDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
//        goToDetailButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
//        routeToGarageButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
    }
    func configureWithGarage(parkingGarages: ParkingObjects) {
        self.parkingGarages = parkingGarages
        
        ImageView.image = #imageLiteral(resourceName: "carexample")
        TitleLabel.text = parkingGarages.Name.removeFirstCharacters()
        parkingSpaceLabel.text = parkingGarages.State
    }
    
    @IBAction func goToDetailButton(_ sender: Any) {
        delegate?.detailsRequested(for: parkingGarages)
    }
    @IBAction func routeToGarageButton(_ sender: Any) {
        delegate?.detailsRequested(for: parkingGarages)
        // hier komt route func
    }
    
    
    func configureWithParkingGarages(parkingGarages: ParkingObjects) {
        self.parkingGarages = parkingGarages

        ImageView.image = #imageLiteral(resourceName: "carexample")
        TitleLabel.text = parkingGarages.Name.removeFirstCharacters()
        parkingSpaceLabel.text = parkingGarages.State
    }
    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.
        
        // details button
        if let result = goToDetailButton.hitTest(convert(point, to: goToDetailButton), with: event) {
            return result
        }
        
        if let route = routeToGarageButton.hitTest(convert(point, to: routeToGarageButton), with: event) {
            return route
        }
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
    
}
