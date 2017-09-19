//
//  SettingsBaseTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 14/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SettingsBaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bottomLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLineTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var upperLine: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.upperLine.isHidden = true
    }
    var settingItem: SettingItem? {
        didSet {
            if let settingItem = self.settingItem {
                setupSettingsCell(settingItem: settingItem)
                
            }
        }
    }
    
    func setupSettingsCell(settingItem: SettingItem) {
        self.titleLabel.text = settingItem.title
        
        if self.bottomLineLeadingConstraint != nil {
            if settingItem.type == SettingItemType.authButton {
                self.bottomLineLeadingConstraint.constant = 0
            } else {
                self.bottomLineLeadingConstraint.constant = 10
            }
            self.bottomLineTrailingConstraint.constant = 0
        }
    }
    
    func setupSettingsCell(title:String) {
        self.titleLabel.text = title
        
        if self.bottomLineLeadingConstraint != nil {
            
            self.bottomLineLeadingConstraint.constant = 10
            self.bottomLineTrailingConstraint.constant = 0
        }
    }
    
    func makeBottomLineFull() {
        if self.bottomLineLeadingConstraint != nil {
            
            self.bottomLineLeadingConstraint.constant = 0
            self.bottomLineTrailingConstraint.constant = 0
        }
    }

}
