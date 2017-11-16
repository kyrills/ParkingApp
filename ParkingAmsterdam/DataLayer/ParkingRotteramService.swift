


import Foundation
import Alamofire
import RealmSwift


class ParkingRotterdamService {
    
    public static let sharedInstance = ParkingRotterdamService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    var garageArray: [ParkingObjects] = []
    var dynamicArray: [ParkingObjects] = []

    func getData(){
        Alamofire.request("http://opendata.technolution.nl/opendata/parkingdata/v1").responseJSON { (jsonData) in
            if let json = jsonData.result.value as? NSDictionary,
                let data = json["parkingFacilities"] as? NSArray {
                for parkingDict in data {
                    if let garage = parkingDict as? NSDictionary{
                        if let garageSite = self.unwrappingStaticFeedDict(dictionary: garage) {
                            
                            self.garageArray.append(garageSite)
                            
                            garageSite.saveData()

                        }

                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:
                    NotificationID.setSecondData),
                                                object: self,
                                                userInfo: ["data2" : self.garageArray])
            }
        }
        
    }
    func getDynamicData(dynamicDataUrl: String , garage: ParkingObjects){
        Alamofire.request(dynamicDataUrl).responseJSON { (jsonData) in
            if let json = jsonData.result.value as? NSDictionary,
                let data = json["parkingFacilityDynamicInformation"] as? NSDictionary {
                if let dict = data as? NSDictionary {
                    if let parkingSite = self.unwrappingDynamicDict(dictionary: dict, garage: garage) {
                        
                        parkingSite.UpdateData()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:
                            NotificationID.setDynamicData),
                                                        object: self,
                                                        userInfo: ["data3" : parkingSite])
                    }
                }

            }

        }
    }
    
    func unwrappingDynamicDict(dictionary: NSDictionary, garage: ParkingObjects) -> ParkingObjects? {
        if let unwrappedDict = dictionary as? NSDictionary {
            if let facilityActualStatus = unwrappedDict["facilityActualStatus"] as? NSDictionary,
                let parkingCapacity = facilityActualStatus["parkingCapacity"] as? Int,
                let vacantSpaces = facilityActualStatus["vacantSpaces"] as? Int,
                let lastUpdated = facilityActualStatus["lastUpdated"] as? Int {
                
                let realm = try! Realm()

                try! realm.write {
                    garage.FreeSpaceShort = String(vacantSpaces)
                    garage.ShortCapacity = String(parkingCapacity)
                    garage.PubDate = String(lastUpdated)
                    
                }

                
                
                return garage
            }
        }
        return nil
    }
    
    func unwrappingStaticFeedDict(dictionary: NSDictionary)  -> ParkingObjects? {
        if let unwrappedDict = dictionary as? NSDictionary {
            if let identifier = unwrappedDict["identifier"] as? String,
                let name = unwrappedDict["name"] as? String,
                let dynamicDataUrl = unwrappedDict["dynamicDataUrl"] as? String,
                let locationForDisplay = unwrappedDict["locationForDisplay"] as? NSDictionary,
                let latitude = locationForDisplay["latitude"] as? Double,
                let longitude = locationForDisplay["longitude"] as? Double{
                
                
                let garage = ParkingObjects.init(id: identifier, latitude: "\(latitude)", longitude: "\(longitude)", Name: name, PubDate: "", State: "", FreeSpaceShort: "", FreeSpaceLong: "", ShortCapacity: "", LongCapacity: "")
                
                
                garage.dynamicDataUrl = dynamicDataUrl
                
                return garage
                
            }
        }
        return nil
    }
    
}















