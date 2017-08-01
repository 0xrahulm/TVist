//
//  ListDateView.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListDateView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.imageView != nil {
            
            self.imageView.alpha = 0.25
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
