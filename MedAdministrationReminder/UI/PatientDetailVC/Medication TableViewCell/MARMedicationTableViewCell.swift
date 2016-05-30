//
//  MARMedicationTableViewCell.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/29/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class MARMedicationTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var medicationNameLabel: UILabel!
    
    var medication:Medication? {
        didSet {
            configureCellMedication(medication!)
        }
    }
    
    func configureCellMedication(medication:Medication) {
        medicationNameLabel.text = "Medication: \(medication.name!)"
        scheduleLabel.text = "Schedule: \(medication.scheduleTime!)"
        dosageLabel.text = "Dosage: \(medication.dosage!)"
        priority.text = "Priority \(medication.priority!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
