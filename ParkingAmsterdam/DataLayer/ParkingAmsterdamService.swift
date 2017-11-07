//
//  ParkingAmsterdamService.swift
//  ParkingAmsterdam
//
//  Created by Trym Lintzen on 07-11-17.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import Foundation
import Alamofire

class ParkingAmsterdamService {
    
    public static let sharedInstance = ParkingAmsterdamService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }

    
    func getParkingData()  {
        
        let ParkingData =  "\(urls.baseURL)"
        Alamofire.request( ParkingData ,
                           method: .get,
                           parameters: nil,
                           encoding: JSONEncoding.default).validate().responseJSON { (response) in
                            
                            switch response.result {
                            case .success:
                                print("Validation Successful")
                                if let result = response.result.value as? NSDictionary {
                                    self.parseData(result: result)
                                }
                            case .failure(let error):
                                print(error)
                            }
                            
        }
    }
    
    func parseData (result: NSDictionary)    {
        var parkingObj: [ParkingObjects] = []
        
        if let features = result["features"] as? NSArray {
            for feature in features {
                if let dict = feature as? NSDictionary,
                    let geometry = dict["geometry"] as? NSDictionary,
                    let properties = dict["properties"] as? NSDictionary,
                    let id = dict["Id"] as? String {
                    
                    if let coordinates: NSArray = geometry["coordinates"] as? NSArray,
                        let latitude = coordinates[0] as? Double,
                        let longitude = coordinates[1] as? Double{
                        
                        
                        if let name = properties["Name"] as? String,
                            let pubDate = properties["PubDate"] as? String,
                            let state = properties["State"] as? String,
                            let freeSpaceShort = properties["FreeSpaceShort"] as? Int,
                            let freeSpaceLong = properties["FreeSpaceLong"] as? Int,
                            let shortCapacity = properties["ShortCapacity"] as? Int,
                            let longCapacity = properties["LongCapacity"] as? Int{
                            let parkingAppObject = ParkingObjects.init(id: id, latitude: latitude, longitude: longitude, Name: name, PubDate: pubDate, State: state, FreeSpaceShort: freeSpaceShort, FreeSpaceLong: freeSpaceLong, ShortCapacity: shortCapacity, LongCapacity: longCapacity)
                            parkingObj.append(parkingAppObject)
                            
                        }
                    }
                    
                    
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationID.setInitialData),
                                            object: self,
                                            userInfo: ["data" : parkingObj])
            
        }
        
        
    }
}




