//
//  STBSingleTableViewCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 01/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class STBSingleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceHNCName: UILabel!
    @IBOutlet weak var deviceIdentifier: UILabel!
    
    var stbDevice: STBDevice? {
        didSet{
            if let dataItem = stbDevice {
                if let diretvHMC = dataItem.directvHMC, diretvHMC.characters.count > 0 {
                    self.deviceHNCName.text = diretvHMC
                } else {
                    self.deviceHNCName.text = "DirecTV"
                }
                self.deviceIdentifier.text = "S/N: "+dataItem.serialNumber
            }
        }
    }
    
    
}
