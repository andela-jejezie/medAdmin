//
//  MARHomeVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

class MARHomeVC: MARGenericVC, MARLoginVCDelegate {
    
    @IBOutlet weak var seeAllPatient: MARButton!
    @IBOutlet weak var addNewNurseButton: MARButton!
    @IBOutlet weak var addNewPatientButton: MARButton!
    @IBOutlet weak var addNewMedicineButton: MARButton!
    @IBOutlet weak var signOutButton: MARButton!
    var allPatientButtonTapped = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        if currentUser == nil {
            signOutButton.hidden = true
        }else {
            signOutButton.hidden = false
        }
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
    }

    @IBAction func onAddNurseButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("HomeVCToAddNurseVCSegue", sender: nil)
    }
    @IBAction func onAddPatientButtonTapped(sender: AnyObject) {
        self.allPatientButtonTapped = false
        if currentUser != nil {
            self.performSegueWithIdentifier("HomeVCToAddPatientVCSegue", sender: nil)
        }else {
           let targetVC = self.storyboard?.instantiateViewControllerWithIdentifier("MARLoginVC") as! MARLoginVC
            targetVC.coreDataHelper = self.coreDataHelper
            targetVC.delegate = self
            self.presentViewController(targetVC, animated: true, completion: nil)
        }
    }
    @IBAction func onAddMedicineButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("HomeVCToAddMedicineVCSegue", sender: nil)
    }
    
    func loginVCDidCompleteLoginWithEmailAddress(email: String) {
        self.currentUser = self.fetchCurrentUser(email)
        if self.currentUser != nil {
            signOutButton.hidden = false;
            if self.allPatientButtonTapped {
                let patientStoryboard = UIStoryboard(name: patientStoryboardName, bundle: nil)
                let targetVC = patientStoryboard.instantiateViewControllerWithIdentifier(patientListIdentifier) as! MARPatientsListVC
                self.navigationController?.pushViewController(targetVC, animated: true)
            }else {
                self.performSegueWithIdentifier("HomeVCToAddPatientVCSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onSeeAllPatientButton(sender: AnyObject) {
        self.allPatientButtonTapped = true
        if currentUser != nil {
            let patientStoryboard = UIStoryboard(name: patientStoryboardName, bundle: nil)
            let targetVC = patientStoryboard.instantiateViewControllerWithIdentifier(patientListIdentifier) as! MARPatientsListVC
            self.navigationController?.pushViewController(targetVC, animated: true)
        }else {
            let targetVC = self.storyboard?.instantiateViewControllerWithIdentifier("MARLoginVC") as! MARLoginVC
            targetVC.coreDataHelper = self.coreDataHelper
            targetVC.delegate = self
            self.presentViewController(targetVC, animated: true, completion: nil)
        }
       
    }
    @IBAction func onSignOutButtonTapped(sender: AnyObject) {
        self.currentUser = nil
        self.signOutButton.hidden = true
        
    }
}
