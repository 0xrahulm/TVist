//
//  SingleSelectionTableViewCell.swift
//  TVist
//
//  Created by Rahul Meena on 16/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SingleSelectionTableViewCell: SettingsBaseTableViewCell {
    
    @IBOutlet weak var selectionIndicatorButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionIndicatorButton.isSelected = selected
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
