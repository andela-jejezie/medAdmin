//
//  HomeTests.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/30/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import XCTest
@testable import MedAdministrationReminder

class HomeTests: XCTestCase {
    
    var viewController: MARHomeVC!
    var  testCoreDataHelper: TestCoreDataHelper!

    override func setUp() {
        super.setUp()
        testCoreDataHelper = TestCoreDataHelper()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MARHomeVC") as! MARHomeVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testCoreDataHelper = nil
    }
    
    func testTitle(){
        let _ = viewController.view
        XCTAssertEqual(viewController.title!, "Home", "view controller should have proper title")
    }
    
    func testButtonButtonsAreSet(){
        let _ = viewController.view
        
        XCTAssertNotNil(viewController.addNewMedicineButton, "should not be nil")
        XCTAssertNotNil(viewController.addNewNurseButton, "should not be nil")
        XCTAssertNotNil(viewController.addNewPatientButton, "should not be nil")
        XCTAssertNotNil(viewController.seeAllPatient, "should not be nil")
        XCTAssertNotNil(viewController.signOutButton, "should not be nil")
        
        XCTAssertEqual(viewController.addNewPatientButton.currentTitle!, "ADD NEW PATIENT", "should be equal")
        XCTAssertEqual(viewController.addNewNurseButton.currentTitle!, "ADD NEW NURSE", "should be equal")
        XCTAssertEqual(viewController.addNewMedicineButton.currentTitle!, "ADD NEW MEDICINE", "should be equal")
        XCTAssertEqual(viewController.seeAllPatient.currentTitle!, "MY PATIENTS", "should be equal")
        XCTAssertEqual(viewController.signOutButton.currentTitle!, "SIGN OUT", "should be equal")

    }
    
    func testSignOutButtonHiddenWhenCurrentUserNotSet(){
        let _ = viewController.view
        XCTAssertTrue(viewController.signOutButton.hidden, "should be hidden")
    }
    
    func testSignOutButtonHiddenAfterCurrentUserSet(){
        viewController.currentUser = TestCoreDataServices.addNurseWithEmail("john@gmail.com", testCoreDataHelper: testCoreDataHelper)
        let _ = viewController.view
        XCTAssertFalse(viewController.signOutButton.hidden, "should be hidden")
    }
    
    
}
