//
//  UIView+Utility.swift
//  Escape
//
//  Created by Ankit on 22/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

public extension UIView {
    
    func hideWithAnimationAndRemoveView(_ removeFromSuperView: Bool, duration: Double) {
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { [unowned self] () -> Void in
            self.alpha = 0.0
            }, completion: { [weak self] (finished: Bool) -> Void in
                
                if let weakSelf = self {
                    if (removeFromSuperView) {
                        weakSelf.removeFromSuperview()
                    } else {
                        weakSelf.isHidden = true
                    }
                }
            })
    }
    
    func hideWithAnimationAndRemoveView(_ removeFromSuperView: Bool) {
        hideWithAnimationAndRemoveView(removeFromSuperView, duration: 0.4)
    }
    
    func hideWithAnimation() {
        hideWithAnimationAndRemoveView(false)
    }
    
    func removeWithAnimation() {
        hideWithAnimationAndRemoveView(true)
    }
    
    func visibleWithAnimationDuration(_ duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.alpha = 1.0
            }, completion: { (finished: Bool) -> Void in
                
        })
    }
    
    func visibleWithAnimationDuration(_ duration: TimeInterval) {
        visibleWithAnimationDuration(duration, delay: 0)
    }
    
    func visibleWithAnimation() {
        visibleWithAnimationDuration(1.0)
    }
    
    func visibleBubbleWithAnimation(){
        
        visibleWithAnimationDuration(0.5)
    }
    
    func disappearWithPopIn(_ duration : TimeInterval , delay : TimeInterval){
        
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.layoutIfNeeded()
            }, completion: {action in
                self.isHidden = true
                self.transform = CGAffineTransform.identity
        })
    }
   
    
}
