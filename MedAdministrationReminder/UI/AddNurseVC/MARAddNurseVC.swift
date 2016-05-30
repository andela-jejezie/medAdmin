//
//  MARAddNurseVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData


class MARAddNurseVC: MARGenericVC {

    @IBOutlet weak var addNurseButton: MARButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Nurse"

    }
    //MARK:- Check if email exist in CoreData
    func isEmailUnique(email:String) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Nurse")
        fetchRequest.predicate = NSPredicate(format:"email == %@",email)
        var error:NSError? = nil
        let count = coreDataHelper.context.countForFetchRequest(fetchRequest, error: &error )
        if count == 0 {
            return true
        }
        return false
    }
    
    @IBAction func onAddNurseButtonTapped(sender: UIButton) {
        if (emailAddressTextField.text == "" || passwordTextField.text == "") {
            self.showAlertWithTitle("Ooops", message: "Email or password is empty.")
            return;
        }
        if !self.isEmailUnique(emailAddressTextField.text!) {
           self.showAlertWithTitle("Ooops", message: "Email already exist.")
            return
        }
        let emailAddress = emailAddressTextField.text!
        let passwordDict:NSDictionary? = NSDictionary(fromKeychainWithKey: keychainIdentifier)
        if let dict = passwordDict as? NSMutableDictionary {
            dict[emailAddress] = passwordTextField.text!
            dict.storeToKeychainWithKey(keychainIdentifier)
            
        }else {
            let dict = NSMutableDictionary()
            dict[emailAddress] = passwordTextField.text!
            dict.storeToKeychainWithKey(keychainIdentifier)
        }
        self.addNurseWithEmail(emailAddress)

    }
    
    //MARK:- Add New Nurse 
    func addNurseWithEmail(email:String) {
        let entity = NSEntityDescription.entityForName("Nurse", inManagedObjectContext: coreDataHelper.context)
        let nurse = Nurse(entity: entity!, insertIntoManagedObjectContext: coreDataHelper.context)
        nurse.email = email
        coreDataHelper.saveContext()
        self.showSuccessAlert()
    }
    
    func showSuccessAlert() {
        let alertView = UIAlertController(title: "Success",
                                          message: "Nurse added", preferredStyle:.Alert)
        let addNurseAction = UIAlertAction(title: "Add Another Nurse", style: .Default) { (_) in
            self.emailAddressTextField.text = ""
            self.passwordTextField.text = ""
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
        alertView.addAction(addNurseAction)
        let doneAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in
            self.performSegueWithIdentifier("unwindToHomeVC", sender: nil)
        }
        alertView.addAction(doneAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    

}
