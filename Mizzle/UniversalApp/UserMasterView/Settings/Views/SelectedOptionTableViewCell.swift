//
//  SelectedOptionTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 19/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SelectedOptionTableViewCell: SettingsBaseTableViewCell {
    
    @IBOutlet weak var selectedOptionLabel: UILabel!
    
    override func setupSettingsCell(settingItem: SettingItem) {
        super.setupSettingsCell(settingItem: settingItem)
        
        selectedOptionLabel.text = settingItem.subTitle
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
