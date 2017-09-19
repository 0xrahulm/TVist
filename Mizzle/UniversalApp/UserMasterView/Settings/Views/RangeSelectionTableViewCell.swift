//
//  RangeSelectionTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 19/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class RangeSelectionTableViewCell: SettingsBaseTableViewCell {
    
    let kRangeOffset:Double = 6
    let kTimeOffset: Int = 23
    
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var selectedRangeOptionLabel: UILabel!
    
    override func setupSettingsCell(settingItem: SettingItem) {
        super.setupSettingsCell(settingItem: settingItem)
        
        selectedRangeOptionLabel.text = settingItem.subTitle
    }
    
    
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        rangeSlider.addTarget(self, action: #selector(RangeSelectionTableViewCell.valueChangedForSlider(_:)), for: .valueChanged)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func valueChangedForSlider(_ sender: RangeSlider) {
        let lowerValue = sender.lowerValue
        let upperValue = sender.upperValue
        
        
        var actualLowerTime = Int(lowerValue+kRangeOffset)
        var actualUpperTime = Int(upperValue+kRangeOffset)
        
        if actualLowerTime > kTimeOffset {
            actualLowerTime = actualLowerTime - kTimeOffset
        }
        
        if actualUpperTime > kTimeOffset {
            actualUpperTime = actualUpperTime - kTimeOffset
        }
        
        self.selectedRangeOptionLabel.text = "\(stringForTimeValue(value: actualLowerTime)) - \(stringForTimeValue(value: actualUpperTime))"
    }
    
    func stringForTimeValue(value: Int) -> String {
        
        if value > 11 {
            let pValue = value - 12
            if pValue == 0 {
                return "12 pm"
            } else {
                return "\(pValue) pm"
            }
        } else {
            if value == 0 {
                return "12 am"
            } else {
                return "\(value) am"
            }
        }
    }
}
