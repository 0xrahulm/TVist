//
//  CustomPresentAnimationController.swift
//  Escape
//
//  Created by Rahul Meena on 26/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresented:Bool = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        containerView.addSubview(toViewController.view)
        
        if isPresented {
            toViewController.view.transform = CGAffineTransformMakeScale(0.65, 0.65)
            toViewController.view.alpha = 0.5
        } else {
            containerView.sendSubviewToBack(toViewController.view)
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .CurveLinear, animations: {
            if self.isPresented {
                toViewController.view.alpha = 1.0
                toViewController.view.transform = CGAffineTransformIdentity
            } else {
                fromViewController.view.alpha = 0.0
                fromViewController.view.transform = CGAffineTransformMakeScale(0.65, 0.65)
            }
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }
}
