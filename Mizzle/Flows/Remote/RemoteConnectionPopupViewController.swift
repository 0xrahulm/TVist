//
//  RemoteConnectionPopupViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 01/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol RemoteConnectionPopupDelegate: class {
    func didTapOnSearchConnectedDevices()
}

class RemoteConnectionPopupViewController: UIViewController {
    var presentingVC: UIViewController?
    var presentedVCObj : CustomPopupPresentationController?

    var delegate: RemoteConnectionPopupDelegate?
    
    var dismissEvent: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapOnSearchConnectedDevices(sender: UIButton) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceConnectPopupSearchConnectedDevice)
        dismissEvent = false
        self.dismiss(animated: true) {
            if let delegate = self.delegate {
                delegate.didTapOnSearchConnectedDevices()
            }
        }
    }
    
    @IBAction func didTapOnDontHaveDirecTV(sender: UIButton) {
        LocalStorageVader.sharedVader.setFlagForKey(.DontShowRemoteConnectBanner)
        AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceConnectPopupDontHaveDirecTV)
        dismissEvent = false
        self.dismiss(animated: true, completion: nil)
    }
}


extension RemoteConnectionPopupViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: 310, height: 230, yOffset: self.view.frame.size.height/2-115, cornerRadius : 5)
        presentedVCObj = presentationController
        return presentationController;
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed != self {
            return nil
        }
        
        if dismissEvent {
            AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceConnectPopupDismissed)
        }
        return CustomPresentationAnimationViewController(isPresenting: false)
    }
}
