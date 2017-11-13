import Foundation
import RealmSwift

class ParkingObjects : Object {
    
    @objc dynamic var id: String?
    
    
    @objc dynamic var latitude: NSNumber?
    
    @objc dynamic var longitude: NSNumber?
    @objc dynamic var Name : String?
    @objc dynamic var PubDate: String?
    @objc dynamic var State: String?
    @objc dynamic var FreeSpaceShort: String?
    @objc dynamic var FreeSpaceLong: String?
    @objc dynamic var ShortCapacity : String?
    @objc dynamic var LongCapacity : String?
    
    convenience init(id: String,latitude: NSNumber, longitude: NSNumber, Name : String , PubDate: String, State: String, FreeSpaceShort: String, FreeSpaceLong: String , ShortCapacity : String, LongCapacity : String) {
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
    

    

    func saveData() {
        // Get the default Realm
        let realm = try! Realm()
        
        // Persist your data easily
        try! realm.write {
            realm.add(self)
        }
    }
    
    func retrieveData(id: String) -> ParkingObjects{
        let realm = try! Realm()
        
        // Query Realm for all dogs less than 2 years old
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@", self.id!)
        return parkingData.first!
    }

}
