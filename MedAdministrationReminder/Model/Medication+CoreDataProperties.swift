//
//  Medication+CoreDataProperties.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/29/16.
//  Copyright © 2016 Andela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Medication {

    @NSManaged var dosage: NSNumber?
    @NSManaged var name: String?
    @NSManaged var priority: String?
    @NSManaged var scheduleTime: NSDate?
    @NSManaged var patients: NSSet?

}
