//
//  UpgradeNowPopupViewController.swift
//  TVist
//
//  Created by Rahul Meena on 24/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UpgradeNowPopupViewController: UIViewController {
    
    @IBOutlet weak var premiumFeatureLabel: UILabel!
    @IBOutlet weak var premiumDescription: UILabel!
    
    var featureIdentifier: FeatureIdentifier?
    
    var presentingVC: UIViewController?
    var presentedVCObj : CustomPopupPresentationController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TVist Premium"
        
        if let featureIdentifier = featureIdentifier {
            
            switch featureIdentifier {
            case .airtimeAlerts:
                self.premiumFeatureLabel.text = "Airing Alerts only available in Premium"
                break
            case .filters:
                self.premiumFeatureLabel.text = "Advanced Filters only available in Premium"
                break
            case .sorting:
                self.premiumFeatureLabel.text = "Advanced Sorting only available in Premium"
                break
            case .channelFilters:
                self.premiumFeatureLabel.text = "Channel Filters only available in Premium"
                break
            case .advancedListing:
                self.premiumFeatureLabel.text = "Advanced Listings only available in Premium"
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let popupText = self.premiumFeatureLabel.text {
         
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UpgradeNowPopupShown, properties: ["Popup Text": popupText])
        }
    }
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let featureIdentifier = queryParams["feature"] as? FeatureIdentifier {
            self.featureIdentifier = featureIdentifier
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        if let popupText = self.premiumFeatureLabel.text {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UpgradeNowPopupDismissTap, properties: ["Popup Text": popupText])
        }
        self.dismissPopup()
    }
    
    @IBAction func upgradeNowButtonTapped(_ sender: Any) {
        
        if let popupText = self.premiumFeatureLabel.text {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UpgradeNowPopupUpgradeNowTap, properties: ["Popup Text": popupText])
        }
        
        self.dismiss(animated: true) {
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openTVistPremiumView, queryParams: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UpgradeNowPopupViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: 310, height: 305, yOffset: 0, cornerRadius: 4)
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
        return CustomPresentationAnimationViewController(isPresenting: false)
    }
}
