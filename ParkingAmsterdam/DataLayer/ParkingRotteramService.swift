


import Foundation
import Alamofire
import RealmSwift


class ParkingRotterdamService {
    
    public static let sharedInstance = ParkingRotterdamService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    func getData(){
        Alamofire.request("http://opendata.technolution.nl/opendata/parkingdata/v1").responseJSON { (jsonData) in
            var garageArray: [ParkingObjects] = []
            if let json = jsonData.result.value as? NSDictionary,
                let data = json["parkingFacilities"] as? NSArray {
                for parkingDict in data {
                    if let garage = parkingDict as? NSDictionary{
                        let garage = self.unwrappingStaticFeedDict(dictionary: garage)
                        garageArray.append(garage!)
   // what to write to append every value from identiefier to the array
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:
                            NotificationID.setSecondData),
                                                        object: self,
                                                        userInfo: ["data2" : garageArray])
                    }
                }
            }
        }

    }
    
    // can i iterate the data from the static and dynamic url wth the id like down here
    //
    //    func getStaticData(identifier: String){
    //        Alamofire.request("http://opendata.technolution.nl/opendata/parkingdata/v1/static\(identifier)").responseJSON { (jsonData) in
    //            if let json = jsonData.result.value as? NSDictionary,
    //                let urls = json["staticDataUrl"] as? NSArray {
    
    //
    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:
    //                        NotificationID.),
    //                                                    object: self,
    //                                                    userInfo: [])
    //                }
    //            }
    //        }
    //    }
    //
    
    // unwrapping dict, only has identifier in it because i could not get ID to work
    
    func getDynamicData(dynamicUrl: String , garage: ParkingObjects){
        Alamofire.request(dynamicUrl).responseJSON { (jsonData) in
            if let json = jsonData.result.value as? NSDictionary,
                let data = json["parkingFacilityDynamicInformation"] as? NSDictionary {
                self.unwrappingDynamicDict(dictionary: data, garage: garage)
            }
        }
    }
    
    //Data frm the dynamic link cntained in the
//    "parkingFacilityDynamicInformation": {
    //    "facilityActualStatus": {
        //    "open": true,
        //    "full": false,
        //    "parkingCapacity": 30,
        //    "vacantSpaces": 30,
        //    "lastUpdated": 1510738879
    //    },
    //    "description": "",
    //    "identifier": "5829fb06-ee4a-4762-946c-ed6209edf7d5",
    //    "name": "P03 - Dek Stadspoort"
//    }
    func unwrappingDynamicDict(dictionary: NSDictionary, garage: ParkingObjects) -> ParkingObjects? {
        if let unwrappedDict = dictionary as? NSDictionary {
            if let facilityActualStatus = unwrappedDict["facilityActualStatus"] as? NSDictionary,
                let full = facilityActualStatus["full"] as? String,
                let parkingCapacity = facilityActualStatus["parkingCapacity"] as? String,
                let vacantSpaces = facilityActualStatus["vacantSpaces"] as? String,
                let lastUpdated = facilityActualStatus["lastUpdated"] as? Int {
                
                garage.State = facilityActualStatus
                
                return garage
            }
        }
        return nil
    }
    
    //Static feed
//    {
//    "dynamicDataUrl": "http://opendata.technolution.nl/opendata/parkingdata/v1/dynamic/8d85bbdb-8bbd-4a24-b35f-85f21186ec04",
//    "staticDataUrl": "http://opendata.technolution.nl/opendata/parkingdata/v1/static/8d85bbdb-8bbd-4a24-b35f-85f21186ec04",
//    "limitedAccess": false,
//    "locationForDisplay": {
    //    "coordinatesType": "WGS84",
    //    "latitude": 52.2490470982696,
    //    "longitude": 6.16317987442017
    //   },
//    "identifier": "8d85bbdb-8bbd-4a24-b35f-85f21186ec04",
//    "name": "P06 - Sluisstraat"
//    }
    func unwrappingStaticFeedDict(dictionary: NSDictionary) -> ParkingObjects? {
        if let unwrappedDict = dictionary as? NSDictionary {
            if let identifier = unwrappedDict["identifier"] as? String,
                let name = unwrappedDict["name"] as? String,
                let dynamicDataUrl = unwrappedDict["dynamicDataUrl"] as? String,
                let locationForDisplay = unwrappedDict["locationForDisplay"] as? NSDictionary,
                let latitude = locationForDisplay["latitude"] as? Double,
                let longitude = locationForDisplay["longitude"] as? Double{
                
                
                let garage = ParkingObjects.init(id: identifier, latitude: "\(latitude)", longitude: "\(longitude)", Name: name, PubDate: "", State: "", FreeSpaceShort: "", FreeSpaceLong: "", ShortCapacity: "", LongCapacity: "")
                
                getDynamicData(dynamicUrl: dynamicDataUrl, garage: garage)
                
                return garage
            }
        }
        return nil
    }

}















