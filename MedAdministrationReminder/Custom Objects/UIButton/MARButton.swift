//
//  MARButton.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class MARButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.backgroundColor = UIColor.MARButtonBlueColor().CGColor
        self.layer.cornerRadius = 5.0
        self.tintColor = UIColor.whiteColor()
    }

}
