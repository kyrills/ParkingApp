import Foundation
import RealmSwift

class ParkingObjects: Object {
    
    @objc dynamic var id: String?
    @objc dynamic var latitude: String?
    @objc dynamic var longitude: String?
    @objc dynamic var Name : String?
    @objc dynamic var PubDate: String?
    @objc dynamic var State: String?
    @objc dynamic var FreeSpaceShort: String?
    @objc dynamic var FreeSpaceLong: String?
    @objc dynamic var ShortCapacity : String?
    @objc dynamic var LongCapacity : String?
    @objc dynamic var favourite: Bool = false
    @objc dynamic var distanceInMeters: String = ""
    
    convenience required init(id: String, latitude: String, longitude: String ,Name : String, PubDate: String,State: String, FreeSpaceShort: String,FreeSpaceLong: String,ShortCapacity : String,LongCapacity : String) {
        self.init()
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.Name = Name
        self.PubDate = PubDate
        self.State = State
        self.FreeSpaceShort = FreeSpaceShort
        self.FreeSpaceLong = FreeSpaceLong
        self.ShortCapacity = ShortCapacity
        self.LongCapacity = LongCapacity
    }
    
    func saveDistance(distance: String) {
        // Get the default Realm
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        if let parkingSite = parkingData.first {
            // Persist your data easily
            try! realm.write {
                parkingSite.distanceInMeters = distance
            }
        }
    }

    
    func saveData() {
        // Get the default Realm
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        if let parkingSite = parkingData.first {
            // Persist your data easily
            try! realm.write {
                parkingSite.FreeSpaceLong = self.FreeSpaceLong
                ///
            }
        } else {
            // Persist your data easily
            try! realm.write {
                realm.add(self)
            }
        }


    }
    
    func sortByDistance() -> [ParkingObjects]  {
        // Get the default Realm
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        
    }
    
    func favouriteParkingSpot() -> Bool{
        
        return false
    }

    static func retrieveAllData() -> [ParkingObjects] {
        var allParkingData: [ParkingObjects] = []
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self)
        for object in parkingData{
            allParkingData += [object]
        }
        return allParkingData
    }
    
    
    func retrieveData() -> ParkingObjects{
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for parking data object
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        return parkingData.first!
    }
    
    
}
