//
//  CustomDoneButton.swift
//  Escape
//
//  Created by Rahul Meena on 23/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomDoneButton: UIButton {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.center = CGPoint(x: 15, y: self.frame.size.height/2)
        
        self.addSubview(activityIndicator)
    }
    
    var enableButton: Bool {
        get {
            return self.isEnabled
        }
        set {
            self.isEnabled = newValue
            
            if(newValue) {
                self.setTitleColor(UIColor.white, for: .normal)
                self.backgroundColor = UIColor.styleGuideActionButtonBlue()
            } else {
                self.setTitleColor(UIColor.styleGuideBodyTextColor(), for: .normal)
                self.backgroundColor = UIColor.styleGuideInputColor()
            }
        }
    }
    
    var _loading: Bool = false
    
    var isLoading: Bool {
        get {
            return self._loading
        }
        set {
            self._loading = newValue
            
            if newValue {
                enableButton = false
                activityIndicator.startAnimating()
            } else {
                
                enableButton = true
                activityIndicator.stopAnimating()
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
