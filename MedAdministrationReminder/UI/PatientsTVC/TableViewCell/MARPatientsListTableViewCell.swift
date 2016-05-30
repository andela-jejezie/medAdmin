//
//  MARPatientsListTableViewCell.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/29/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class MARPatientsListTableViewCell: UITableViewCell {

    @IBOutlet weak var onMedicationLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var patient:Patient? {
        didSet {
            self.configureCellForData(patient!)
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func configureCellForData(patient:Patient) {
        emailAddressLabel.text = patient.email!
        fullNameLabel.text = patient.fullName!
        if patient.medications?.count > 0 {
            onMedicationLabel.text = "On medication: YES"
        }else {
            onMedicationLabel.text = "On medication: NO"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .Default
    }
    override func prepareForReuse() {
        emailAddressLabel.text = ""
        fullNameLabel.text = ""
        onMedicationLabel.text = ""
        super.prepareForReuse()
    }

}
