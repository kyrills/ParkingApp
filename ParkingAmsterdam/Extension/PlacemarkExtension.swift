//
//  PlacemarkExtension.swift
//  ParkingAmsterdam
//
//  Created by Kyrill van Seventer on 14/11/2017.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import Foundation
import MapKit
extension MKPlacemark {
    
    func parseAddress() -> String {
        
        let firstSpace = (self.subThoroughfare != nil &&
            self.thoroughfare != nil) ? " " : ""
        
        let comma = (self.subThoroughfare != nil || self.thoroughfare != nil) &&
            (self.subAdministrativeArea != nil || self.administrativeArea != nil) ? ", " : ""
        
        let secondSpace = (self.subAdministrativeArea != nil &&
            self.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            self.subThoroughfare ?? "",
            firstSpace,
            // street name
            self.thoroughfare ?? "",
            comma,
            // city®
            self.locality ?? "",
            secondSpace,
            // state
            self.administrativeArea ?? ""
        )
        
        return addressLine
    }
}
