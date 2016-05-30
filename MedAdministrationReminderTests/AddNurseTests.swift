//
//  AddNurseTests.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/30/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import XCTest
import CoreData
@testable import MedAdministrationReminder

class AddNurseTests: XCTestCase {

    var viewController: MARAddNurseVC!
    var  testCoreDataHelper: TestCoreDataHelper!
    override func setUp() {
        super.setUp()
        testCoreDataHelper = TestCoreDataHelper()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MARAddNurseVC") as! MARAddNurseVC
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testCoreDataHelper = nil
    }
    
    func testHasTitle() {
        let _ = viewController.view
        XCTAssertEqual(viewController.title!, "Add Nurse", "should be equal")
    }
    
    func testButtonIsSet(){
        let _ = viewController.view
        XCTAssertNotNil(viewController.addNurseButton)
        XCTAssertEqual(viewController.addNurseButton.currentTitle!, "ADD NURSE", "should be equal")
    }
    
    func testAllTextFieldAreSet() {
        let _ = viewController.view
        XCTAssertNotNil(viewController.emailAddressTextField)
        XCTAssertNotNil(viewController.passwordTextField)
    }
    
    func testAddNurse() {
        let nurse = TestCoreDataServices.addNurseWithEmail("john@gmail.com", testCoreDataHelper: testCoreDataHelper)
        XCTAssertNotNil(nurse, "medicine should not be nil")
        XCTAssertTrue(nurse?.email == "john@gmail.com")
    }
    
    func testIsEmailUnique() {
        let response = TestCoreDataServices.isUniqueEmail("john@gmail.com", testCoreDataHelper: testCoreDataHelper)
        XCTAssertTrue(response, "Email is unique")
    }
    
    func testIsEmailUniqueAfterAddingNurse() {
        _ = TestCoreDataServices.addNurseWithEmail("john@gmail.com", testCoreDataHelper: testCoreDataHelper)
        let response = TestCoreDataServices.isUniqueEmail("john@gmail.com", testCoreDataHelper: testCoreDataHelper)
        XCTAssertFalse(response, "Email exist")
    }
    
    func testContextIsSavedAfterAddingNurse() {
        expectationForNotification(
            NSManagedObjectContextDidSaveNotification, object:
        testCoreDataHelper.context){
            notification in
            return true
        }
        _ = TestCoreDataServices.addNurseWithEmail("john@gmail.com", testCoreDataHelper: testCoreDataHelper)
        waitForExpectationsWithTimeout(2.0){
            error in
            XCTAssertNil(error, "Save did not occur")
        }
        
    }

}
