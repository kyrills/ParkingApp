import Foundation
import RealmSwift
import MapKit
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
    @objc dynamic var dynamicDataUrl : String = ""
    @objc dynamic var favourite: Bool = false
    @objc dynamic var distanceInMeters: String = ""
    @objc dynamic var address: String = ""

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
    func UpdateData() {
        // Get the default Realm
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        if let parkingSite = parkingData.first {
            // Persist your data easily
            try! realm.write {
                parkingSite.FreeSpaceLong = self.FreeSpaceLong
                parkingSite.FreeSpaceShort = self.FreeSpaceShort
                parkingSite.LongCapacity = self.LongCapacity
                parkingSite.PubDate = self.PubDate
                parkingSite.ShortCapacity = self.ShortCapacity
            
        }
    }
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

    func saveAddressData() {
        // Get the default Realm
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        
        if let park = parkingData.first {
            if park.address == "" {
                let addressLocation = CLLocationCoordinate2D.init(latitude: Double(self.latitude!)!,
                                                                  longitude: Double(self.longitude!)!)
                
                
                addressLocation.convertToAddress(onCompletion: { (address) in
                    try! realm.write {
                        park.address = address
                        ///
                    }
                })
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
                parkingSite.FreeSpaceShort = self.FreeSpaceShort
                parkingSite.LongCapacity = self.LongCapacity
                parkingSite.PubDate = self.PubDate
                parkingSite.ShortCapacity = self.ShortCapacity
        }
        } else {
            // Persist your data easily
            try! realm.write {
                realm.add(self)
            }
        }
    }
    
    func favouriteParkingSpot() -> ParkingObjects? {
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
            return parkingSite

        }
        return nil
    }
    
    static func sortByDistance() -> [ParkingObjects]  {
        var allParkingData: [ParkingObjects] = []
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self).sorted(byKeyPath: "distanceInMeters", ascending: true)
        for object in parkingData{
            allParkingData += [object]
        }
        return allParkingData
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
    
    static func retrieveAllData() -> [ParkingObjects] {
        var allParkingData: [ParkingObjects] = []
        let realm = try! Realm()
        let parkingData = realm.objects(ParkingObjects.self)
        for object in parkingData{
            allParkingData += [object]
        }
        return allParkingData
    }
    
    func retrieveData() -> ParkingObjects?{
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for parking data object
        let parkingData = realm.objects(ParkingObjects.self).filter("id = %@",self.id!)
        if let result = parkingData.first {
            return result
        } else {
            return nil
        }
    }
    
    
}
