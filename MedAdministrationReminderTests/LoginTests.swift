//
//  LoginTests.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/30/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import XCTest
@testable import MedAdministrationReminder

class LoginTests: XCTestCase {
    
    var viewController: MARLoginVC!
    var  testCoreDataHelper: TestCoreDataHelper!
    override func setUp() {
        super.setUp()
        testCoreDataHelper = TestCoreDataHelper()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MARLoginVC") as! MARLoginVC
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testCoreDataHelper = nil
    }
    
    func testHasTitle() {
        let _ = viewController.view
        XCTAssertEqual(viewController.title!, "Login", "should be equal")
    }
    
    func testBarButtonItemsAreSet() {
        let _ = viewController.view
        XCTAssertNotNil(viewController.cancelBarButton, "Should not be nil")
        XCTAssertEqual(viewController.cancelBarButton!.action, #selector(viewController.onCancelButtonTapped(_:)), "Action should be addPerson")
    }
    
    func testButtonIsSet(){
        let _ = viewController.view
        XCTAssertNotNil(viewController.loginButton)
        XCTAssertEqual(viewController.loginButton.currentTitle!, "LOGIN", "should be equal")
    }
    
    func testAllTextFieldAreSet() {
        let _ = viewController.view
        XCTAssertNotNil(viewController.emailAddressTextField)
        XCTAssertNotNil(viewController.passwordTextField)
    }
    
}
