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
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.popupWidth = width
        self.popupHeight = height
        self.popupYOffset = yOffset
        self.cornerRadius = cornerRadius
        
        setupDimmingView()
        
    }
    
    func setCloseButton(){
        let frame = frameOfPresentedViewInContainerView
        
        self.closeButton = UIButton(frame: CGRect(x: popupWidth! - 10, y: frame.origin.y - 55, width: 55,height: 55) )
            closeButton.setImage(UIImage(named: "close-popup"), for: UIControlState())
            closeButton.addTarget(self, action: #selector(CustomPopupPresentationController.dismissView), for: .touchUpInside)
            dimmingView.addSubview(closeButton)
        
        
    }
    
    func setupDimmingView() {
        
        dimmingView = UIView(frame: CGRect(x: 0,y: 0, width: presentingViewController.view.bounds.width,height: presentingViewController.view.bounds.height + 64))
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark)) as UIVisualEffectView
        visualEffectView.frame = dimmingView.bounds
        visualEffectView.alpha = 0.6;
        dimmingView.addSubview(visualEffectView)
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
        setCloseButton()
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        return CGRect(x: (containerView!.frame.width-popupWidth!)/2,y: (containerView!.frame.height-popupHeight!)/2-popupYOffset, width: popupWidth!, height: popupHeight!)
    }

}
