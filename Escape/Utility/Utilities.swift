//
//  Utilities.swift
//  Escape
//
//  Created by Ankit on 07/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

extension UIView {
    
    func hideWithAnimationAndRemoveView(removeFromSuperView: Bool, duration: Double) {
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { [unowned self] () -> Void in
            self.alpha = 0.0
            }, completion: { [weak self] (finished: Bool) -> Void in
                
                if let weakSelf = self {
                    if (removeFromSuperView) {
                        weakSelf.removeFromSuperview()
                    } else {
                        weakSelf.hidden = true
                    }
                }
            })
    }
    
    func hideWithAnimationAndRemoveView(removeFromSuperView: Bool) {
        hideWithAnimationAndRemoveView(removeFromSuperView, duration: 0.4)
    }
    
    func hideWithAnimation() {
        hideWithAnimationAndRemoveView(false)
    }
    
    func removeWithAnimation() {
        hideWithAnimationAndRemoveView(true)
    }
    
    func visibleWithAnimationDuration(duration: NSTimeInterval, delay: NSTimeInterval) {
        self.alpha = 0.0
        self.hidden = false
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.alpha = 1.0
            }, completion: { (finished: Bool) -> Void in
                
        })
    }
    
    func visibleWithAnimationDuration(duration: NSTimeInterval) {
        visibleWithAnimationDuration(duration, delay: 0)
    }
    
    func visibleWithAnimation() {
        visibleWithAnimationDuration(1.0)
    }
    
    func visibleBubbleWithAnimation(){
        
        visibleWithAnimationDuration(0.5)
    }
    
    func disappearWithPopIn(duration : NSTimeInterval , delay : NSTimeInterval){
        
        self.transform = CGAffineTransformIdentity
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            self.layoutIfNeeded()
            }, completion: {action in
                self.hidden = true
                self.transform = CGAffineTransformIdentity
        })
    }
    
}


