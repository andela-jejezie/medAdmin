//
//  MARPatientDetailVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/29/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

let addMedicationSegueIdentifier = "PatientDetailVCToMedicationVCSegue"
let medicationCellIdentifier = "MedicationCell"

class MARPatientDetailVC: MARGenericVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    var patient:Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateSubViews()
        title = "Patient Details"
    }
    
    func populateSubViews() {
        fullNameLabel.text = patient.fullName!
        emailAddressLabel.text = patient.email!
        phoneNumberLabel.text = patient.phoneNumber!
    }
    
    @IBAction func onAddMedicationBarButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier(addMedicationSegueIdentifier, sender: nil)
    }
    
    //MARK:- Configure Cell
    func configureCell(cell: MARMedicationTableViewCell, indexPath: NSIndexPath) {
        let medication = self.patient.medications?.allObjects[indexPath.row] as! Medication
        cell.medication = medication
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == addMedicationSegueIdentifier {
            let targetVC = segue.destinationViewController as! MARAddOrEditVC
            targetVC.patient = self.patient
            targetVC.delegate = self
        }
    }
}

extension MARPatientDetailVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return (self.patient.medications?.count)!
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell =
                tableView.dequeueReusableCellWithIdentifier(
                    medicationCellIdentifier, forIndexPath: indexPath)
                    as! MARMedicationTableViewCell
            
            configureCell(cell, indexPath: indexPath)
            return cell
    }
}

extension MARPatientDetailVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
                   didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let medication = self.patient.medications?.allObjects[indexPath.row] as! Medication
        let targetVC = self.storyboard?.instantiateViewControllerWithIdentifier(addOrEditMedicationVC) as! MARAddOrEditVC
        targetVC.patient = patient
        targetVC.medication = medication
        self.presentViewController(targetVC, animated: true, completion: nil)
    }
}

extension MARPatientDetailVC: addOrEditMedicationDelegate {
    func addOrEditMedicationDidUpdatePatient(patient: Patient) {
        self.patient = patient
        self.tableView.reloadData()
    }
}



