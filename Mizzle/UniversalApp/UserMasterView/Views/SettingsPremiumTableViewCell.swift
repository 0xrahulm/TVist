//
//  SettingsPremiumTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 14/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SettingsPremiumTableViewCell: SettingsBaseTableViewCell {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageAssetView: UIImageView!
    
    
    override func setupSettingsCell(settingItem: SettingItem) {
        super.setupSettingsCell(settingItem: settingItem)
        
        self.subtitleLabel.text = settingItem.subTitle
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
