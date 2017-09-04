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
    var dimmingView: UIView!
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController, width: CGFloat, height: CGFloat, yOffset:CGFloat = 65, cornerRadius:CGFloat = 20) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.popupWidth = width
        self.popupHeight = height
        self.popupYOffset = yOffset
        self.cornerRadius = cornerRadius
        
        setupDimmingView()
        
    }
    
    func setupDimmingView() {
        
        dimmingView = UIView(frame: CGRect(x: 0,y: 0, width: presentingViewController.view.bounds.width,height: presentingViewController.view.bounds.height + 64))
        
        let visualEffectView = UIView(frame: dimmingView.bounds)
        visualEffectView.backgroundColor = UIColor.textColor()
        visualEffectView.alpha = 0.5;
        dimmingView.addSubview(visualEffectView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomPopupPresentationController.dimmingViewTapped(_:)))
        
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    func dismissView(){
        presentedViewController.view.endEditing(true)
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    func dimmingViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        dismissView()
    }
    
    override func presentationTransitionWillBegin() {
        if let presentedView = self.presentedViewController.view {
            
            presentedView.layer.cornerRadius = cornerRadius
            presentedView.clipsToBounds = true
        }
        
        let containerView = self.containerView
        let presentedViewController = self.presentedViewController
        
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        
        containerView!.insertSubview(dimmingView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (coordinatorContext) -> Void in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (coordinatorContext) -> Void in
            self.dimmingView.alpha = 0.0
            ScreenVader.sharedVader.removeDismissedViewController(self.presentedViewController)
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        return CGRect(x: (containerView!.frame.width-popupWidth!)/2,y: (containerView!.frame.height-popupHeight!)/2-popupYOffset, width: popupWidth!, height: popupHeight!)
    }

}
