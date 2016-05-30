//
//  MARAddPatienVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

protocol addPatientVCDelegate:class {
    func addPatientVCDidAddPatient()
}
class MARAddPatienVC: MARGenericVC {
    
    @IBOutlet weak var addPatientButton: MARButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    private var patient:Patient?
    weak var delegate:addPatientVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Patient"
    }
    //MARK:- Check if email Exist
    func isExistingEmailAddress(email:String) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Patient")
        fetchRequest.predicate = NSPredicate(format:"email == %@",email)
        var error:NSError? = nil
        let count = coreDataHelper.context.countForFetchRequest(fetchRequest, error: &error )
        if count == 0 {
            return false
        }
        return true
    }

    @IBAction func onAddPatientButtonTapped(sender: AnyObject) {
        if (emailAddressTextField.text == "" || fullNameTextField.text == "" || phoneNumberTextField.text == "") {
            self.showAlertWithTitle("Ooops", message: "All fields are required.")
            return;
        }
        if self.isExistingEmailAddress(emailAddressTextField.text!) {
            self.showAlertWithTitle("Ooops", message: "Email already exist.")
            return
        }
        self.addPatientWithFullName(fullNameTextField.text!, emailAddress: emailAddressTextField.text!, withPhoneNumber: phoneNumberTextField.text!)
        showSuccessAlert()
    }
    
    //MARK:- Save Patient to core data
    func addPatientWithFullName(name:String, emailAddress email:String, withPhoneNumber phone:String) {
        let entity = NSEntityDescription.entityForName("Patient", inManagedObjectContext: coreDataHelper.context)
        let patient = Patient(entity: entity!, insertIntoManagedObjectContext: coreDataHelper.context)
        patient.fullName = name
        patient.email = email
        patient.nurse = self.currentUser
        patient.phoneNumber = phone
        coreDataHelper.saveContext()
        self.addPatientToCurrentUser(patient)
    }
    
    func showSuccessAlert() {
        let alertView = UIAlertController(title: "Success",
                                          message: "Patient added and associated to you. Scehdule Medication for Patient?", preferredStyle:.Alert)
        let addPatientAction = UIAlertAction(title: "YES", style: .Default) { (_) in
            alertView.dismissViewControllerAnimated(true, completion: nil)
            self.segueToPatientDetailVCWithPatient()
        }
        alertView.addAction(addPatientAction)
        let doneAction = UIAlertAction(title: "NOT NOW", style: .Default) { (_) in
            self.delegate?.addPatientVCDidAddPatient()
           self.navigationController?.popViewControllerAnimated(true)
        }
        alertView.addAction(doneAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func segueToPatientDetailVCWithPatient() {
        let patientStoryboard = UIStoryboard(name: patientStoryboardName, bundle: nil)
        let targetVC = patientStoryboard.instantiateViewControllerWithIdentifier(addOrEditMedicationVC) as! MARAddOrEditVC
        targetVC.patient = patient
        self.presentViewController(targetVC, animated: true, completion: nil)
    }
}
