//
//  MARGenericVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

let keychainIdentifier = "MARLOGIN_KEYCHAIN"
class MARGenericVC: UIViewController {
    var currentUser:Nurse?
    lazy var  coreDataHelper = MARCoreDataHelper()
    
    let unwindToHomeVCSegue = "unwindToHomeVC"
    let patientStoryboardName = "Patient"
    let patientDetailVCIdentifier = "MARPatientDetailVC"
    let patientListIdentifier = "MARPatientsListVC"
    let addOrEditMedicationVC = "MARAddOrEditVC"


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        hideKeyboardWhenBackgroundIsTapped()
        let currentUSerEmail = NSUserDefaults.standardUserDefaults().stringForKey("currentUserEmail")
        guard currentUSerEmail != nil else {
            return
        }
        currentUser = self.fetchCurrentUser(currentUSerEmail!)
    }
    
    func fetchCurrentUser(email:String) -> Nurse? {
        let fetchRequest = NSFetchRequest(entityName: "Nurse")
        fetchRequest.predicate = NSPredicate(format:"email == %@", email)
        do {
            let results = try coreDataHelper.context.executeFetchRequest(fetchRequest) as! [Nurse]
            return results.first
        }catch let error as NSError {
            self.showAlertWithTitle("Ooops", message: error.localizedDescription)

        }
        return nil
    }
    
    //MARK:- Set navigation bar appearance
    func setUpNavigationBar() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.navigationBar.barTintColor = UIColor.MARButtonBlueColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Savoye LET", size: 30)!]
    }
    
    //MARK:- Hide keyboard by tapping anywhere in the view
    
    func hideKeyboard () {
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenBackgroundIsTapped () {
        let tgr = UITapGestureRecognizer(target: self, action:#selector(MARGenericVC.hideKeyboard))
        tgr.cancelsTouchesInView = true
        tgr.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tgr)
    }
    //MARK:- Alert
    func showAlertWithTitle(title:String, message:String) {
        let alertView = UIAlertController(title: title,
                                          message: message, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func addPatientToCurrentUser(patient:Patient) {
        let email = self.currentUser?.email!
        let fetchRequest = NSFetchRequest(entityName: "Nurse")
        fetchRequest.predicate = NSPredicate(format:"email == %@", email!)
        do {
            let results = try coreDataHelper.context.executeFetchRequest(fetchRequest) as! [Nurse]
            currentUser = results.first
            let patients = currentUser?.patients!.mutableCopy() as? NSMutableSet
            patients?.addObject(patient)
            currentUser?.patients = patients?.mutableCopy() as? NSSet
            coreDataHelper.saveContext()
        }catch let error as NSError {
            self.showAlertWithTitle("Ooops", message: error.localizedDescription)
        }
    }
    
    func formatTimeToString(time:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(time)
    }
    
}

