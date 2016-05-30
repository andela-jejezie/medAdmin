//
//  MARLoginVC.swift
//  MedAdministrationReminder
//
//  Created by Johnson Ejezie on 5/28/16.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import UIKit
import CoreData

protocol MARLoginVCDelegate:class {
    func loginVCDidCompleteLoginWithEmailAddress(email:String)
}

class MARLoginVC: MARGenericVC {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: MARButton!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    weak var delegate: MARLoginVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setUpNavBar()
    }
    
    func setUpNavBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 64))
        navBar.items = [self.navItem]
        navBar.barTintColor = UIColor.MARButtonBlueColor()
        navBar.tintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Savoye LET", size: 30)!]
        self.view.addSubview(navBar)
        
    }
    //Check if email Exist in local database
    func doesEmailExist(email:String) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Nurse")
        fetchRequest.predicate = NSPredicate(format:"email == %@",email)
        var error:NSError? = nil
        let count = coreDataHelper.context.countForFetchRequest(fetchRequest, error: &error )
        if count == 0 {
            return false
        }
        return true
    }

    @IBAction func onLoginButtonTapped(sender: AnyObject) {
        if (emailAddressTextField.text == "" || passwordTextField.text == "") {
            self.showAlertWithTitle("Ooops", message: "Email or password is empty.")
            return;
        }
        if !self.doesEmailExist(emailAddressTextField.text!) {
            self.showAlertWithTitle("Ooop", message: "Authentication failed. Please add user as nurse.")
            return
        }
        let emailAddress = emailAddressTextField.text!
        let password = passwordTextField.text!
        self.verifyUserWithEmail(emailAddress, password: password)
    }
    
    //MARK:- Authenticate user
    func verifyUserWithEmail(email:String, password aPassword:String) {
        let passwordDict = NSDictionary(fromKeychainWithKey: keychainIdentifier)
        if let dict = passwordDict {
            if let kpassword = dict[email] {
                if kpassword as! String == aPassword {
                    NSUserDefaults.standardUserDefaults().setValue(email, forKey: "currentUserEmail")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.delegate?.loginVCDidCompleteLoginWithEmailAddress(email)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else {
                    self.showAlertWithTitle("Ooop", message: "Authentication failed. Incorrect password.")
                    return
                }
            }else {
                self.showAlertWithTitle("Ooop", message: "Authentication failed. Please check your login details and ensure the details has been added as nurse.")
                return
            }
        }
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
