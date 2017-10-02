//
//  UIViewController+Utility.swift
//  Escape
//
//  Created by Ankit on 21/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func fixNavigationBarCorruption() {
        if let coordinator = self.transitionCoordinator {
            
            if coordinator.initiallyInteractive {
                let mapTable = NSMapTable<AnyObject, AnyObject>(keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.strongMemory, capacity: 0)
                
                if #available(iOS 11.0, *) {
                    coordinator.notifyWhenInteractionChanges({ (context) in
                        if !context.isCancelled {
                            if let navVC = self.navigationController {
                                for view in navVC.navigationBar.subviews {
                                    let anims = NSMutableArray()
                                    if let animationKeys = view.layer.animationKeys() {
                                        
                                        for animationKey in animationKeys {
                                            if let anim = view.layer.animation(forKey: animationKey) as? CABasicAnimation, let keyPath = anim.keyPath {
                                                
                                                let animCopy = CABasicAnimation(keyPath: keyPath)
                                                
                                                animCopy.fromValue = view.layer.value(forKeyPath: keyPath)
                                                animCopy.toValue = view.layer.value(forKeyPath: keyPath)
                                                animCopy.byValue = anim.byValue
                                                // CAPropertyAnimation properties
                                                animCopy.isAdditive = anim.isAdditive
                                                animCopy.isCumulative = anim.isCumulative
                                                animCopy.valueFunction = anim.valueFunction
                                                // CAAnimation properties
                                                animCopy.timingFunction = anim.timingFunction
                                                animCopy.delegate = anim.delegate
                                                animCopy.isRemovedOnCompletion = anim.isRemovedOnCompletion
                                                // CAMediaTiming properties
                                                animCopy.speed = anim.speed
                                                animCopy.repeatCount = anim.repeatCount
                                                animCopy.repeatDuration = anim.repeatDuration
                                                animCopy.autoreverses = anim.autoreverses
                                                animCopy.fillMode = anim.fillMode
                                                // We want our new animations to be instantaneous, so set the duration to zero.
                                                // Also set both the begin time and time offset to 0.
                                                animCopy.duration = 0
                                                animCopy.beginTime = 0
                                                animCopy.timeOffset = 0
                                                anims.add(animCopy)
                                            }
                                        }
                                        
                                    }
                                    
                                    mapTable.setObject(anims, forKey: view)
                                }
                            }
                            
                        }
                    })
                } else {
                    coordinator.notifyWhenInteractionEnds({ (context) in
                        if let navVC = self.navigationController {
                            for view in navVC.navigationBar.subviews {
                                let anims = NSMutableArray()
                                if let animationKeys = view.layer.animationKeys() {
                                    
                                    for animationKey in animationKeys {
                                        if let anim = view.layer.animation(forKey: animationKey) as? CABasicAnimation, let keyPath = anim.keyPath {
                                            
                                            let animCopy = CABasicAnimation(keyPath: keyPath)
                                            
                                            animCopy.fromValue = view.layer.value(forKeyPath: keyPath)
                                            animCopy.toValue = view.layer.value(forKeyPath: keyPath)
                                            animCopy.byValue = anim.byValue
                                            // CAPropertyAnimation properties
                                            animCopy.isAdditive = anim.isAdditive
                                            animCopy.isCumulative = anim.isCumulative
                                            animCopy.valueFunction = anim.valueFunction
                                            // CAAnimation properties
                                            animCopy.timingFunction = anim.timingFunction
                                            animCopy.delegate = anim.delegate
                                            animCopy.isRemovedOnCompletion = anim.isRemovedOnCompletion
                                            // CAMediaTiming properties
                                            animCopy.speed = anim.speed
                                            animCopy.repeatCount = anim.repeatCount
                                            animCopy.repeatDuration = anim.repeatDuration
                                            animCopy.autoreverses = anim.autoreverses
                                            animCopy.fillMode = anim.fillMode
                                            // We want our new animations to be instantaneous, so set the duration to zero.
                                            // Also set both the begin time and time offset to 0.
                                            animCopy.duration = 0
                                            animCopy.beginTime = 0
                                            animCopy.timeOffset = 0
                                            anims.add(animCopy)
                                        }
                                    }
                                    
                                }
                                
                                mapTable.setObject(anims, forKey: view)
                            }
                        }
                    })
                }
               
                
                coordinator.animate(alongsideTransition: nil, completion: { (context) in
                    for view in mapTable.keyEnumerator() {
                        if let v = view as? UIView {
                            if let anims = mapTable.object(forKey: v) as? [CABasicAnimation] {
                                for anim in anims {
                                   v.layer.add(anim, forKey: anim.keyPath)
                                }
                            }
                        }
                    }
                })
            }
        }
        
        
//        // If we have a transition coordinator and it was initially interactive when it started,

//
//            // The completion block here gets run after the view controller transition animation completes (or fails)
//            [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//
//                // Iterate over the mapTable's keys (views)
//                for (UIView *view in mapTable.keyEnumerator) {
//
//                // Get the modified animations for this view that we made when the interactive portion of the transition finished
//                NSArray *anims = [mapTable objectForKey:view];
//
//                // ... and add them back to the view's layer
//                for (CABasicAnimation *anim in anims) {
//                [view.layer addAnimation:anim forKey:anim.keyPath];
//                }
//                }
//                }];
//        }
//    }
    }
    
    @objc func setObjectsWithQueryParameters(_ queryParams: [String:Any]) {
        //vcFootPrint = createClassFootPrintWith(theClassName, queryParams: queryParams)
        // Receive Parameterized Data
    }
    
    func addNavigationBarDoneButton() {
        if let _ = self.navigationController {
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIViewController.dismissPopup))
            self.navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    @objc func dismissPopup() {
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: { 
                self.didDismissPopup()
            })
        } else {
            self.dismiss(animated: true, completion: {
                self.didDismissPopup()
            })
        }
    }
    
    func didDismissPopup() {
        //overriden in base classes
    }
}
