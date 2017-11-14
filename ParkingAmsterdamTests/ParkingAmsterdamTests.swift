//
//  ParkingAmsterdamTests.swift
//  ParkingAmsterdamTests
//
//  Created by Kyrill van Seventer on 14/11/2017.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import XCTest
@testable import ParkingAmsterdam
@testable import RealmSwift

class ParkingAmsterdamTests: XCTestCase {
    var parking: ParkingObjects?
    override func setUp() {
        super.setUp()
        parking = ParkingObjects.init(id: "1", latitude: "0", longitude: "0", Name: "", PubDate: "", State: "", FreeSpaceShort: "", FreeSpaceLong: "", ShortCapacity: "", LongCapacity: "")
        parking!.saveData()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsIntiallyNotFavourited() {
        let retrieved = parking!.retrieveData()
        XCTAssert(retrieved.favourite == false, "passed is false")
    }
    
    func testIsIntiallyFavouriteStateChangedToTrue() {
        parking!.favouriteParkingSpot()
    }
    
}
