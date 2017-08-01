//
//  ChannelButton.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ChannelButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var lineView: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.contentMode = .scaleAspectFit
        
        
    }
    
    
    func setSelected(selected: Bool) {
        self.isSelected = selected
    }

}
