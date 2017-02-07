//
//  CustomPopupPresentationController.swift
//  Escape
//
//  Created by Ankit on 09/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomPopupPresentationController: UIPresentationController {
    
    var popupWidth: CGFloat? = 280
    var popupHeight: CGFloat? = 200
    var popupYOffset: CGFloat = 65
    var cornerRadius : CGFloat = 20
    var closeButton : UIButton!
    var dimmingView: UIView!
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController, width: CGFloat, height: CGFloat, yOffset:CGFloat = 65, cornerRadius:CGFloat = 20) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        self.popupWidth = width
        self.popupHeight = height
        self.popupYOffset = yOffset
        self.cornerRadius = cornerRadius
        
        setupDimmingView()
        
    }
    
    func setCloseButton(){
        let frame = frameOfPresentedViewInContainerView()
                   closeButton = UIButton(frame: CGRectMake(popupWidth! - 10, frame.origin.y - 55, 55,55) )
            closeButton.setImage(UIImage(named: "close-popup"), forState: .Normal)
            closeButton.addTarget(self, action: #selector(CustomPopupPresentationController.dismissView), forControlEvents: .TouchUpInside)
            dimmingView.addSubview(closeButton)
        
        
    }
    
    func setupDimmingView() {
        
        dimmingView = UIView(frame: CGRectMake(0,0, CGRectGetWidth(presentingViewController.view.bounds),CGRectGetHeight(presentingViewController.view.bounds) + 64))
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = dimmingView.bounds
        visualEffectView.alpha = 0.6;
        dimmingView.addSubview(visualEffectView)
    }
    
    func dismissView(){
        presentedViewController.view.endEditing(true)
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
        dismissView()
    }
    
    override func presentationTransitionWillBegin() {
        let presentedView = self.presentedViewController.view
        presentedView.layer.cornerRadius = cornerRadius
        presentedView.clipsToBounds = true
        
        let containerView = self.containerView
        let presentedViewController = self.presentedViewController
        
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        
        containerView!.insertSubview(dimmingView, atIndex: 0)
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (coordinatorContext) -> Void in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (coordinatorContext) -> Void in
            self.dimmingView.alpha = 0.0
            ScreenVader.sharedVader.removeDismissedViewController(self.presentedViewController)
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView()!.frame = frameOfPresentedViewInContainerView()
        setCloseButton()
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return CGRectMake((CGRectGetWidth(containerView!.frame)-popupWidth!)/2,(CGRectGetHeight(containerView!.frame)-popupHeight!)/2-popupYOffset, popupWidth!, popupHeight!)
    }

}
