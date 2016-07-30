//
//  UIButton+Utility.swift
//  Escape
//
//  Created by Ankit on 29/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation



extension UIButton{
    
    func unfollowViewWithAnimate(animate :Bool){
        
        self.setTitle("  + Follow  ", forState: .Normal)
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 1.0
        if animate{
            popAnimate()
        }
    }
    func followViewWithAnimate(animate : Bool){
        
        self.setTitle("  Following  ", forState: .Normal)
        self.backgroundColor = UIColor.greenColor()
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.layer.borderWidth = 0.0
        if animate{
            popAnimate()
        }
    }
    func popAnimate(){
        UIView.animateWithDuration(0.1 ,
                                   animations: {
                                    self.transform = CGAffineTransformMakeScale(1.3, 1.3)
            },
                                   completion: { finish in
                                    UIView.animateWithDuration(0.1){
                                        self.transform = CGAffineTransformIdentity
                                    }
        })
    }
    
}


