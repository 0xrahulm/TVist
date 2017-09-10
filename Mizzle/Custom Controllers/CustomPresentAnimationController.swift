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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        
        if isPresented {
            toViewController.view.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
            toViewController.view.alpha = 0.5
        } else {
            containerView.sendSubview(toBack: toViewController.view)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            if self.isPresented {
                toViewController.view.alpha = 1.0
                toViewController.view.transform = CGAffineTransform.identity
            } else {
                fromViewController.view.alpha = 0.0
                fromViewController.view.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
            }
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }
}
