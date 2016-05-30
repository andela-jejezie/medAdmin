//
//  MARAddOrEditVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/29/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

protocol addOrEditMedicationDelegate:class {
    func addOrEditMedicationDidUpdatePatient(patient:Patient)
}

private let priority = ["High", "Medium", "Low"]
class MARAddOrEditVC: MARGenericVC {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var DosageTextField: UITextField!
    @IBOutlet weak var scheduleTextField: UITextField!
    @IBOutlet weak var medicineTextField: UITextField!
    
    weak var delegate:addOrEditMedicationDelegate?
    var patient:Patient!
    var medication:Medication!
    var pickOption = [String]()
    var medicines = [String]()
    var activeTextField = UITextField()
    var scheduleDate:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFieldDelegates()
        self.getListOfMedicines()
        self.setUpNavBar()
        populateSubViews()
        setupNotificationSettings()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if medicines.count == 0 {
            self.noMedicineAlert()
        }
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
    
    func populateSubViews() {
        if let aMedication = self.medication {
            medicineTextField.text = aMedication.name!
            scheduleTextField.text = self.formatTimeToString(aMedication.scheduleTime!)
            DosageTextField.text = aMedication.dosage!.stringValue
            priorityTextField.text = aMedication.priority!
        }
    }
    //MARK:- Fetch Medicine Entity and use map to get Array of names
    func getListOfMedicines() {
        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        do {
            let results = try coreDataHelper.context.executeFetchRequest(fetchRequest) as! [Medicine]
            for medicine in results {
                medicines.append(medicine.name!)
            }
        }catch let error as NSError {
            self.showAlertWithTitle("Ooops", message: error.localizedDescription)
        }
    }
    
    lazy var nameSortDescriptor: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "name",
                                  ascending: true,
                                  selector: #selector(NSString.localizedStandardCompare(_:)))
        return sd
    }()
    
    //MARK:- Set up textfield delegate
    func setUpTextFieldDelegates() {
        medicineTextField.delegate = self
        scheduleTextField.delegate = self
        DosageTextField.delegate = self
        priorityTextField.delegate = self
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        medicineTextField.inputView = pickerView
        priorityTextField.inputView = pickerView
        
    }
    
    @IBAction func onCancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onSaveButtonTapped(sender: AnyObject) {
        if (medicineTextField.text == "" || scheduleTextField.text == "" || DosageTextField.text == "" || priorityTextField.text == "") {
            self.showAlertWithTitle("Ooops", message: "All fields are required.")
            return;
        }
        self.addMedicationToPatient()
    }
    
    //Add medication to patient 
    func addMedicationToPatient() {
        let entity = NSEntityDescription.entityForName("Medication", inManagedObjectContext: coreDataHelper.context)
        let aMedication = Medication(entity: entity!, insertIntoManagedObjectContext: coreDataHelper.context)
        aMedication.name = self.medicineTextField.text!
        aMedication.scheduleTime = self.scheduleDate
        aMedication.dosage = NSNumber(integer: Int(self.DosageTextField.text!)!)
        aMedication.priority = self.priorityTextField.text
        let fetchRequest = NSFetchRequest(entityName: "Patient")
        fetchRequest.predicate = NSPredicate(format:"email == %@",self.patient.email!)
        do {
            let results = try coreDataHelper.context.executeFetchRequest(fetchRequest) as! [Patient]
            let fetchedPatient = results.first!
            let medicationSet = fetchedPatient.medications!.mutableCopy() as! NSMutableSet
            medicationSet.addObject(aMedication)
            fetchedPatient.medications = medicationSet.mutableCopy() as? NSSet
            coreDataHelper.saveContext()
            self.patient = fetchedPatient
            self.scheduleReminderForMedicationOfPatient(fetchedPatient, forMedication: aMedication)
            showSuccessAlert()
        }catch let error as NSError {
            self.showAlertWithTitle("Ooops", message: error.localizedDescription)
        }
    }
    
    @IBAction func scheduleTextFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        self.scheduleDate = sender.date
        scheduleTextField.text = self.formatTimeToString(sender.date)
    }
    
    //MARK:- Schedule notification for medication
    func scheduleReminderForMedicationOfPatient(patient:Patient, forMedication medication:Medication) {
        let notification = UILocalNotification()
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(([.Hour, .Minute]), fromDate: medication.scheduleTime!)

        notification.fireDate = NSDate().dateWithTime(components.hour, minute: components.minute)
        notification.repeatInterval = NSCalendarUnit.Day
        notification.timeZone = NSCalendar.currentCalendar().timeZone
        notification.alertBody = "It's time for \(patient.fullName!) medication: \(medication.name!). \(medication.dosage!) Dose"
        
        notification.hasAction = true
        notification.alertAction = "View"
        notification.userInfo = [
            "patientName":patient.fullName!,
            "dosage":medication.dosage!,
            "medication":medication.name!,
            "time":scheduleTextField.text!,
            "priority":medication.priority!
        ]
        
        notification.applicationIconBadgeNumber =
            UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    //Set up notification
    func setupNotificationSettings() {
        // Specify the notification types.
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]

        let formAction = UIMutableUserNotificationAction()
        formAction.identifier = "justInform"
        formAction.title = "OK, got it"
        formAction.activationMode = UIUserNotificationActivationMode.Background
        formAction.destructive = false
        formAction.authenticationRequired = false
        
        let actionsArray = NSArray(objects: formAction)
        // Specify the category related to the above actions.
        let medicationReminderCategory = UIMutableUserNotificationCategory()
        medicationReminderCategory.identifier = "medicationReminderCategory"
        medicationReminderCategory.setActions(actionsArray as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        let categoriesForSettings = NSSet(objects: medicationReminderCategory)

        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        
    }
    
    func noMedicineAlert () {
            self.view.endEditing(true)
            let alertView = UIAlertController(title: "Notice",
                                              message: "No medicine has been added to the database yet. Please add medicine.", preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in
                alertView.dismissViewControllerAnimated(true, completion: nil)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alertView = UIAlertController(title: "Success",
                                          message: "Medication schedule saved", preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            alertView.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.addOrEditMedicationDidUpdatePatient(self.patient)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}

extension MARAddOrEditVC:UIPickerViewDataSource, UIPickerViewDelegate {
    //MARK:- PickerView Delegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activeTextField.text = pickOption[row]
    }
}

extension MARAddOrEditVC:UITextFieldDelegate {
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.medicineTextField {
            if medicines.count == 0 {
                noMedicineAlert()
                return
            }
            pickOption = medicines
        }else if textField == self.priorityTextField {
            pickOption = priority
        }
        self.activeTextField = textField
    }
}

extension NSDate {
    func dateWithTime(hour: Int, minute: Int) -> NSDate? {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(([.Day, .Month, .Year]), fromDate: self)
        components.hour = hour
        components.minute = minute
        let newDate = calendar.dateFromComponents(components)
        return newDate
    }
}
