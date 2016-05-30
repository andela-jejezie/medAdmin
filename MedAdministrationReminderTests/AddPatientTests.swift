//
//  AddPatientTests.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/30/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import XCTest
import CoreData
@testable import MedAdministrationReminder

class AddPatientTests: XCTestCase {
    
    var viewController: MARAddPatienVC!
    var  testCoreDataHelper: TestCoreDataHelper!
    override func setUp() {
        super.setUp()
        testCoreDataHelper = TestCoreDataHelper()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MARAddPatienVC") as! MARAddPatienVC

    }
    
    func testHasTitle() {
        let _ = viewController.view
        XCTAssertEqual(viewController.title!, "Add Patient", "should be equal")
    }
    
    func testButtonIsSet(){
        let _ = viewController.view
        XCTAssertNotNil(viewController.addPatientButton)
        XCTAssertEqual(viewController.addPatientButton.currentTitle!, "ADD PATIENT", "should be equal")
    }
    
    func testAllTextFieldAreSet() {
        let _ = viewController.view
        XCTAssertNotNil(viewController.fullNameTextField)
        XCTAssertNotNil(viewController.emailAddressTextField)
        XCTAssertNotNil(viewController.phoneNumberTextField)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testCoreDataHelper = nil
    }
    
    func testAddPatient() {
        let patient = TestCoreDataServices.addPatientWithFullName("john john", emailAddress: "john@gmail.com", withPhoneNumber: "9876543", testCoreDataHelper: testCoreDataHelper)
        XCTAssertNotNil(patient, "patient should not be nil")
        XCTAssertTrue(patient?.email == "john@gmail.com")
    }

    
    func testIsEmailUniqueAfterAddingPatient() {
        _ = TestCoreDataServices.addPatientWithFullName("john john", emailAddress: "john@gmail.com", withPhoneNumber: "9876543", testCoreDataHelper: testCoreDataHelper)
        let response = TestCoreDataServices.isExistingEmailAddress("john@gmail.com", testCoreDataHelper: testCoreDataHelper)
        XCTAssertTrue(response, "Email exist")
    }
    
    func testContextIsSavedAfterAddingPatient() {
        expectationForNotification(
            NSManagedObjectContextDidSaveNotification, object:
        testCoreDataHelper.context){
            notification in
            return true
        }
        _ = TestCoreDataServices.addPatientWithFullName("john john", emailAddress: "john@gmail.com", withPhoneNumber: "9876543", testCoreDataHelper: testCoreDataHelper)
        waitForExpectationsWithTimeout(2.0){
            error in
            XCTAssertNil(error, "Save did not occur")
        }
        
    }

}
