//
//  SettingsOnOff.swift
//  TVist
//
//  Created by Rahul Meena on 14/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol SettingsOnOffSwitchProtocol: class {
    func onOffSwitchValueDidChange(isOn: Bool)
}

class SettingsOnOffTableViewCell: SettingsBaseTableViewCell {
    
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    weak var onOffSwitchDelegate: SettingsOnOffSwitchProtocol?

    @IBAction func switchValueDidChange(_ sender: Any) {
        if let onOffSwitchDelegate = self.onOffSwitchDelegate {
            onOffSwitchDelegate.onOffSwitchValueDidChange(isOn: onOffSwitch.isOn)
        }
    }

}
