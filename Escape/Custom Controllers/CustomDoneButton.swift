//
//  CustomDoneButton.swift
//  Escape
//
//  Created by Rahul Meena on 23/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomDoneButton: RNLoadingButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hideTextWhenLoading = false
        self.isLoading = false
        self.activityIndicatorAlignment = .right
    }
    
    var enableButton: Bool {
        get {
            return self.isEnabled
        }
        set {
            self.isEnabled = newValue
            
            if(newValue) {
                self.alpha = 1.0
            } else {
                self.alpha = 0.6
            }
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
