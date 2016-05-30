//
//  Patient+CoreDataProperties.swift
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

extension Patient {

    @NSManaged var email: String?
    @NSManaged var fullName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var medications: NSSet?
    @NSManaged var nurse: Nurse?

}
