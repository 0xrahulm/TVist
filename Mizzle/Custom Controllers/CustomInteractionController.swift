//
//  CustomInteractionController.swift
//  Escape
//
//  Created by Rahul Meena on 15/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomInteractionController: UIPercentDrivenInteractiveTransition {
    var navigationController: UINavigationController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    var completionSeed: CGFloat {
        return 1 - percentComplete
    }
    
    func attachToViewController(_ viewController: UIViewController) {
        navigationController = viewController.navigationController
        setupGestureRecognizer(viewController.view)
    }
    
    fileprivate func setupGestureRecognizer(_ view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CustomInteractionController.handlePanGesture(_:))))
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let viewTranslation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        switch gestureRecognizer.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
        case .changed:
            let const = CGFloat(viewTranslation.x / gestureRecognizer.view!.frame.size.width)
            shouldCompleteTransition = const > 0.3
            update(const)
        case .cancelled, .ended:
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                cancel()
            } else {
                finish()
            }
        default:
            Logger.debug("Swift switch must be exhaustive, thus the default")
        }
    }
}
