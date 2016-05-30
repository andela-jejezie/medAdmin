//
//  AddMedicineTests.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/30/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import XCTest
import CoreData
@testable import MedAdministrationReminder

class AddMedicineTests: XCTestCase {
    
    var viewController: MARAddMedicineVC!
    var  testCoreDataHelper: TestCoreDataHelper!
    override func setUp() {
        super.setUp()
        testCoreDataHelper = TestCoreDataHelper()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MARAddMedicineVC") as! MARAddMedicineVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testCoreDataHelper = nil
    }
    
    func testHasATitle () {
        let _ = viewController.view
        XCTAssertEqual(viewController.title!, "Add Medicine", "view should show a proper title")
    }
    


    
    func testAddMedicine() {
       let medicine = TestCoreDataServices.addMedicine("Panadol", testCoreDataHelper: testCoreDataHelper)
        XCTAssertNotNil(medicine, "medicine should not be nil")
        XCTAssertTrue(medicine!.name == "Panadol")
    }
    
    func testDoesMedicineExist() {
        let response = TestCoreDataServices.fetchMedicine("drug", testCoreDataHelper: testCoreDataHelper)
        XCTAssertFalse(response, "drug does not exist")
    }
    
    func testDoesMedicineExistAfterAddingMedicine() {
        _ = TestCoreDataServices.addMedicine("drug", testCoreDataHelper: testCoreDataHelper)
        let response = TestCoreDataServices.fetchMedicine("drug", testCoreDataHelper: testCoreDataHelper)
        XCTAssertTrue(response, "drug already exist")
    }
    
    func testContextIsSavedAfterAddingMedicine() {
        expectationForNotification(
            NSManagedObjectContextDidSaveNotification, object:
        testCoreDataHelper.context){
            notification in
            return true
        }
        _ = TestCoreDataServices.addMedicine("Panadol", testCoreDataHelper: testCoreDataHelper)
        waitForExpectationsWithTimeout(2.0){
            error in
            XCTAssertNil(error, "Save did not occur")
        }
        
    }
    
}
