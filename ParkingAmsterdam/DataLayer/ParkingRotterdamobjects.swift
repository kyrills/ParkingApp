
import Foundation
import RealmSwift

class ParkingRotterdamobjects: Object {
    
    @objc dynamic var identifier: String?
    // static
    @objc dynamic var name: String?
    @objc dynamic var latitude: String?
    @objc dynamic var longitude: String?
    // dynamic
    @objc dynamic var facilityActualStatus: String?
    @objc dynamic var full: String?
    @objc dynamic var parkingCapacity: String?
    @objc dynamic var vacantSpaces: String?
    @objc dynamic var lastUpdated: String?
    
    
    convenience required init(identifier: String,name: String,latitude: String,longitude: String,facilityActualStatus: String, full: String,parkingCapacity: String,vacantSpaces: String,lastUpdated: String) {
        self.init()
        self.identifier = identifier
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.facilityActualStatus = facilityActualStatus
        self.full = full
        self.parkingCapacity = parkingCapacity
        self.vacantSpaces = vacantSpaces
        self.lastUpdated = lastUpdated
    }
    
    
    func saveData() {
        // Get the default Realm
        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            realm.add(self)
        }
    }
    
    func retrieveData() -> ParkingRotterdamobjects{
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for parking data object
        let parkingData = realm.objects(ParkingRotterdamobjects.self).filter("identifier = %@",self.identifier!)
        return parkingData.first!
    }
}
