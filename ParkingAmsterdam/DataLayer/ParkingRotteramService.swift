


import Foundation
import Alamofire
import RealmSwift


class ParkingRotterdamService {
    
    public static let sharedInstance = ParkingRotterdamService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    func getData(id: String){
        Alamofire.request("http://opendata.technolution.nl/opendata/parkingdata/v1").responseJSON { (jsonData) in
            var idArray: [ParkingRotterdamobjects] = []
            if let json = jsonData.result.value as? NSDictionary,
                let data = json["parkingFacilities"] as? NSArray {
                for identifier in data {
                    if let ID = identifier as? NSDictionary{
                        
                        idArray.append(ID)
   // what to write to append every value from identiefier to the array
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:
                            NotificationID.setSecondData),
                                                        object: self,
                                                        userInfo: ["data2" : idArray])
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
    }
    func unwrappingDict(dictionary: NSDictionary) -> ParkingRotterdamobjects? {
        if let unwrappedDict = dictionary as? NSDictionary {
            if let identifier = unwrappedDict["identifier"] as? String,
                let name = unwrappedDict["name"] as? String,
                let latitude = unwrappedDict["latitude"] as? Double,
                let longitude = unwrappedDict["longitude"] as? Double,
                let facilityActualStatus = unwrappedDict["facilityActualStatus"] as? String,
                let full = unwrappedDict["full"] as? String,
                let parkingCapacity = unwrappedDict["parkingCapacity"] as? String,
                let vacantSpaces = unwrappedDict["vacantSpaces"] as? String,
                let lastUpdated = unwrappedDict["lastUpdated"] as? Int {
                let garages = ParkingRotterdamobjects.init(identifier: identifier, name: name, latitude: latitude, longitude: longitude, facilityActualStatus: facilityActualStatus, full: full, parkingCapacity: parkingCapacity, vacantSpaces: vacantSpaces, lastUpdated: lastUpdated)
                
                return garages
            }
        }
        return nil
    }
}















