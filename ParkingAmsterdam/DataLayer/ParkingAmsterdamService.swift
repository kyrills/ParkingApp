import Foundation
import Alamofire
import RealmSwift
class ParkingAmsterdamService {
    
    public static let sharedInstance = ParkingAmsterdamService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    @objc func getParkingData()  {
        
        let ParkingData =  "\(urls.baseURL)"
        Alamofire.request( ParkingData ,
                           method: .get,
                           parameters: nil,
                           encoding: JSONEncoding.default).validate().responseJSON { (response) in
                            
                            switch response.result {
                            case .success:
//                                print("Validation Successful")
                                if let result = response.result.value as? NSDictionary {
                                    self.parseData(result: result)
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
    
    func parseData (result: NSDictionary) {
        var parkingObj: [ParkingObjects] = []
        if let features = result["features"] as? NSArray {
            for feature in features {
                if let key = feature as? NSDictionary{
                    let properties = getDictionary(with: "properties", from: key) ?? [:]
                    let geometry = getDictionary(with: "geometry", from: key) ?? [:]
                    let coords = parseCoord(geometry: geometry)
                    if let parkAppObject = parseProperties(properties: properties,
                                                           id: key["Id"] as? String ?? "",
                                                           latitude: coords.lat,
                                                           longitude: coords.lng) {
                        parkingObj.append(parkAppObject)
                        
                        parkAppObject.saveData()
                    }
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationID.setInitialData),
                                            object: self,
                                            userInfo: ["data" : parkingObj])
        }
    }
    
    func getDictionary(with key: String, from feature: NSDictionary) -> NSDictionary? {
        if let geo = feature[key] as? NSDictionary{
            return geo
        } else {
            return nil
        }
    }
    
    func parseProperties(properties: NSDictionary, id: String, latitude: Double, longitude: Double) -> ParkingObjects?{
        if let name = properties["Name"] as? String,
            let pubDate = properties["PubDate"] as? String,
            let state = properties["State"] as? String{
            
            let freeSpaceShort = properties["FreeSpaceShort"] as? String ?? ""
            let freeSpaceLong = properties["FreeSpaceLong"] as? String ?? ""
            let shortCapacity = properties["ShortCapacity"] as? String ?? ""
            let longCapacity = properties["LongCapacity"] as? String ?? ""
            
            let parkingAppObject = ParkingObjects.init(id: id,
                                                       latitude: "\(latitude)",
                                                       longitude: "\(longitude)",
                                                       Name: name,
                                                       PubDate: pubDate,
                                                       State: state,
                                                       FreeSpaceShort: freeSpaceShort,
                                                       FreeSpaceLong: freeSpaceLong,
                                                       ShortCapacity: shortCapacity,
                                                       LongCapacity: longCapacity)
            return parkingAppObject
        }
        return nil
    }
    
    func parseCoord(geometry: NSDictionary) -> (lat: Double, lng: Double){
        if let coordinates: NSArray = geometry["coordinates"] as? NSArray,
            let longitude = coordinates[0] as? Double,
            let latitude = coordinates[1] as? Double{
            return(lat: latitude, lng: longitude)
        }
        return (0,0)
    }
}

