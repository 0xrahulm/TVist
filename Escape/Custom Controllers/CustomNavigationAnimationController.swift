//
//  CustomNavigationAnimationController.swift
//  Escape
//
//  Created by Rahul Meena on 15/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomNavigationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var reverse: Bool = false
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        guard let toView = toViewController.view, let fromView = fromViewController.view else {
            return
        }
        
        var newToFrame = transitionContext.finalFrame(for: toViewController)
        var newFromFrame = fromView.frame // for reverse
        
        if reverse {
            
            containerView.insertSubview(toView, belowSubview: fromView)
        } else {
            
            newToFrame.origin.x = newToFrame.size.width
            toView.frame = newToFrame
            containerView.addSubview(toView)
        }
        
        newToFrame.origin.x = 0
        newFromFrame.origin.x = fromView.frame.size.width
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            if self.reverse {
                fromView.frame = newFromFrame
            } else {
                toView.frame = newToFrame
            }
            
            }, completion: {
                finished in
                
                if (transitionContext.transitionWasCancelled) {
                    toView.removeFromSuperview()
                } else {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
