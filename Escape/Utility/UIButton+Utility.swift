//
//  UIButton+Utility.swift
//  Escape
//
//  Created by Ankit on 29/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

extension UIButton{
    
     func followViewWithAnimate(animate :Bool){
        
        self.setTitle("UNFOLLOW", forState: .Normal)
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.escapeBlueColor(), forState: .Normal)
        self.layer.borderColor = UIColor.escapeBlueColor().CGColor
        self.layer.borderWidth = 1.0
        self.enabled = true
        if animate{
            popButtonAnimate()
        }
    }
    
    func unfollowViewWithAnimate(animate : Bool){
        
        self.setTitle("+ FOLLOW", forState: .Normal)
        self.backgroundColor = UIColor.escapeBlueColor()
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.layer.borderWidth = 0.0
        self.enabled = true
        if animate{
            popButtonAnimate()
        }
    }
    
    
    func disableButton(animate : Bool){
        
        self.setTitle("loading...", forState: .Normal)
        self.backgroundColor = UIColor.grayColor()
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.layer.borderWidth = 0.0
        self.enabled = false
        if animate{
            popButtonAnimate()
        }
    }
    
    
    func popButtonAnimate(){
        UIView.animateWithDuration(0.08 ,
                                   animations: {
                                    self.transform = CGAffineTransformMakeScale(1.2, 1.2)
            },
                                   completion: { finish in
                                    UIView.animateWithDuration(0.08){
                                        self.transform = CGAffineTransformIdentity
                                    }
        })
    }
    
    func selectedFalseForCollection(){
        self.selected = false
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        
    }
    
    func selectedTrueForCollection(){
        self.selected = true
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.escapeBlueColor().CGColor
        self.setTitleColor(UIColor.escapeBlueColor(), forState: .Normal)
        
    }
    
}



