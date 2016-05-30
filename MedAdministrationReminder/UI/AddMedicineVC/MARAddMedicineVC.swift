//
//  MARAddMedicineVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData
class MARAddMedicineVC: MARGenericVC {
    
    @IBOutlet weak var addMedicineButton: MARButton!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Medicine"
    }
    
    //MARK:- Check if email exist in CoreData
    func doesMedicineExist(name:String) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format:"name == %@",name)
        var error:NSError? = nil
        let count = coreDataHelper.context.countForFetchRequest(fetchRequest, error: &error )
        if count == 0 {
            return false
        }
        return true
    }
    
    @IBAction func onAddMedicineButtonTapped(sender: AnyObject) {
        if nameTextField.text == "" {
            self.showAlertWithTitle("Ooops", message: "name can not be empty.")
            return
        }
        var name = nameTextField.text!
         name = name.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        if doesMedicineExist(name.lowercaseString) {
            self.showAlertWithTitle("Ooops", message: "Medicine exist already.")
            return
        }
        self.addNewMedicine(name.lowercaseString)
    }
    
    //MARK:- Add New Medicine
    func addNewMedicine(name:String) {
        let entity = NSEntityDescription.entityForName("Medicine", inManagedObjectContext: coreDataHelper.context)
        let medicine = Medicine(entity: entity!, insertIntoManagedObjectContext: coreDataHelper.context)
        medicine.name = name
        coreDataHelper.saveContext()
        self.showSuccessAlert()
    }
    
    func showSuccessAlert() {
        let alertView = UIAlertController(title: "Success",
                                          message: "Medicine added", preferredStyle:.Alert)
        let addNurseAction = UIAlertAction(title: "Add Another Medicine?", style: .Default) { (_) in
            self.nameTextField.text = ""
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
