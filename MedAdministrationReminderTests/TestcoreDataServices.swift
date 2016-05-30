//
//  TestcoreDataServices.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/30/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData

@testable import MedAdministrationReminder
class TestCoreDataServices {
    
     class func addMedicine(name:String, testCoreDataHelper:TestCoreDataHelper) -> Medicine? {
        let entity = NSEntityDescription.entityForName("Medicine", inManagedObjectContext: testCoreDataHelper.context)
        let medicine = Medicine(entity: entity!, insertIntoManagedObjectContext: testCoreDataHelper.context)
        medicine.name = name
        testCoreDataHelper.saveContext()
        return medicine
    }
    
    class func fetchMedicine(name:String, testCoreDataHelper:TestCoreDataHelper)->Bool {
        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format:"name == %@",name)
        var error:NSError? = nil
        let count = testCoreDataHelper.context.countForFetchRequest(fetchRequest, error: &error )
        if count == 0 {
            return false
        }
        return true
    }
    
    class func isUniqueEmail(email:String, testCoreDataHelper:TestCoreDataHelper)-> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Nurse")
        fetchRequest.predicate = NSPredicate(format:"email == %@",email)
        var error:NSError? = nil
        let count = testCoreDataHelper.context.countForFetchRequest(fetchRequest, error: &error )
        if count == 0 {
            return true
        }
        return false
    }
    
    class func addNurseWithEmail(email:String, testCoreDataHelper:TestCoreDataHelper)-> Nurse? {
        let entity = NSEntityDescription.entityForName("Nurse", inManagedObjectContext: testCoreDataHelper.context)
        let nurse = Nurse(entity: entity!, insertIntoManagedObjectContext: testCoreDataHelper.context)
        nurse.email = email
        testCoreDataHelper.saveContext()
        return nurse
    }
    
    class func addPatientWithFullName(name:String, emailAddress email:String, withPhoneNumber phone:String, testCoreDataHelper:TestCoreDataHelper)->Patient? {
        let entity = NSEntityDescription.entityForName("Patient", inManagedObjectContext: testCoreDataHelper.context)
        let patient = Patient(entity: entity!, insertIntoManagedObjectContext: testCoreDataHelper.context)
        patient.fullName = name
        patient.email = email
        patient.phoneNumber = phone
        testCoreDataHelper.saveContext()
        return patient
    }
    
    class func isExistingEmailAddress(email:String, testCoreDataHelper:TestCoreDataHelper) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Patient")
        fetchRequest.predicate = NSPredicate(format:"email == %@",email)
        var error:NSError? = nil
        let count = testCoreDataHelper.context.countForFetchRequest(fetchRequest, error: &error )
        if count == 0 {
            return false
        }
        return true
    }
    

}