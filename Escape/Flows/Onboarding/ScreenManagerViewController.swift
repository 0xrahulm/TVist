//
//  ScreenManagerViewController.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum StoryBoardIdentifier : String{
    case Onboarding = "Onboarding"
}

class ScreenManagerViewController: UIViewController {
    
    var currentStoryBoard : UIStoryboard?
    var currentPresentedViewController : UIViewController?
    var presentedViewControllers : [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreenVader.sharedVader.screenManagerVC = self
        UserDataProvider.sharedDataProvider.getSecurityToken()

        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initialViewBootUp()
    }
    
    private func initialViewBootUp(){
    
        if (true){ // if not login, open onBoardingflow
            currentPresentedViewController  = initialViewControllerFor(.Onboarding)
            
            if let currentPresentedViewController = currentPresentedViewController {
                presentViewController(currentPresentedViewController, animated: false, completion: nil)
                presentedViewControllers = []
                presentedViewControllers.append(currentPresentedViewController)
                
            }
            
        }else{
            
        }
        
    }
    
    
    private func initialViewControllerFor(storyboardId: StoryBoardIdentifier) -> UIViewController {
        return UIStoryboard(name: storyboardId.rawValue, bundle: nil).instantiateInitialViewController()!
    }
    
    private func instantiateViewControllerWith(storyboard: StoryBoardIdentifier, forIdentifier: String) -> UIViewController {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewControllerWithIdentifier(forIdentifier)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

  

}
