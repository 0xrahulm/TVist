//
//  UIButton+Utility.swift
//  Escape
//
//  Created by Ankit on 29/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

extension UIButton{
    
     func followViewWithAnimate(_ animate :Bool){
        
        self.setTitle("UNFOLLOW", for: UIControlState())
        self.backgroundColor = UIColor.white
        self.setTitleColor(UIColor.mizzleBlueColor(), for: UIControlState())
        self.layer.borderColor = UIColor.mizzleBlueColor().cgColor
        self.layer.borderWidth = 1.0
        self.isEnabled = true
        if animate{
            popButtonAnimate()
        }
    }
    
    func unfollowViewWithAnimate(_ animate : Bool){
        
        self.setTitle("+ FOLLOW", for: UIControlState())
        self.backgroundColor = UIColor.mizzleBlueColor()
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.layer.borderWidth = 0.0
        self.isEnabled = true
        if animate{
            popButtonAnimate()
        }
    }
    
    
    func disableButton(_ animate : Bool){
        
        self.setTitle("loading...", for: UIControlState())
        self.backgroundColor = UIColor.gray
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.layer.borderWidth = 0.0
        self.isEnabled = false
        if animate{
            popButtonAnimate()
        }
    }
    
    
    func popButtonAnimate(){
        UIView.animate(withDuration: 0.08 ,
                                   animations: {
                                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.08, animations: {
                                        self.transform = CGAffineTransform.identity
                                    })
        })
    }
    
    func selectedFalseForCollection(){
        self.isSelected = false
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.setTitleColor(UIColor.gray, for: UIControlState())
        
        
    }
    
    func selectedTrueForCollection(){
        self.isSelected = true
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mizzleBlueColor().cgColor
        self.setTitleColor(UIColor.mizzleBlueColor(), for: UIControlState())
        
    }
    
}



