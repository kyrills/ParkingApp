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
    
    //Changed the saveData so that it will only update dynamic values. Since all initial values are loaded at startup.
    func saveData() {
        // Get the default Realm
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        if let parkingSite = parkingData.first {
            // Persist your data easily
            try! realm.write {
                parkingSite.FreeSpaceLong = self.FreeSpaceLong
                parkingSite.FreeSpaceShort = self.FreeSpaceShort
                parkingSite.LongCapacity = self.LongCapacity
                parkingSite.ShortCapacity = self.ShortCapacity
                parkingSite.PubDate = self.PubDate
            }
        } else {
            // Persist your data easily
            try! realm.write {
                realm.add(self)
            }
        }
    }
    
    func favouriteParkingSpot() {
        //This handles the favourites button.
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        if let parkingSite = parkingData.first {
            // Persist your data easily
            try! realm.write {
                
                //Switches the state of the bool.
                if parkingSite.favourite == false{
                    parkingSite.favourite = true
                } else{
                    parkingSite.favourite = false
                }
            }
        } else {
            // Persist your data easily
            try! realm.write {
                realm.add(self)
            }
        }
    }
    
    static func sortedByFavourite() -> [ParkingObjects]{
        var allSortedFavourites: [ParkingObjects] = []
        let realm = try! Realm()
        let sortedFavourites = realm.objects(ParkingObjects.self).filter("favourite = true")
        for i in sortedFavourites{
            allSortedFavourites += [i]
        }
        return allSortedFavourites
    }
    
    func retrieveData() -> ParkingObjects{
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for parking data object
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        return parkingData.first!
    }
}
