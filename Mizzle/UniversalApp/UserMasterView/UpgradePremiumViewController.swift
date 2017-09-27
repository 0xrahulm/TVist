//
//  UpgradePremiumViewController.swift
//  TVist
//
//  Created by Rahul Meena on 15/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import StoreKit

class UpgradePremiumViewController: UIViewController {
    
    @IBOutlet weak var monthlyPurchaseView: UIView!
    @IBOutlet weak var yearlyPurchaseView: UIView!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var yearlyPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productStartFetching(start: true)
        
        IAPVader.sharedVader.delegate = self
        IAPVader.sharedVader.fetchAvailableProducts()
        
    }
    
    func productStartFetching(start: Bool) {
        self.monthlyPurchaseView.isHidden = start
        self.yearlyPurchaseView.isHidden = start
        
        if start {
            self.loadingView.startAnimating()
        } else {
            self.loadingView.stopAnimating()
        }
    }
    
    @IBAction func didTapOnMonthlyPurchase(_ sender: AnyObject) {
        productStartFetching(start: true)
        IAPVader.sharedVader.purchaseMonthlyPremium()
        AnalyticsVader.sharedVader.basicEvents(eventName: .UserUpgradeMonthlyPurchaseButtonTap)
    }
    
    @IBAction func didTapOnYearlyPurchase(_ sender: AnyObject) {
        IAPVader.sharedVader.purchaseYearlyPremium()
        AnalyticsVader.sharedVader.basicEvents(eventName: .UserUpgradeYearlyPurchaseButtonTap)
    }
    
    @IBAction func didTapOnPrivacyPolicy(_ sender: Any) {
        if let url = URL(string: "http://www.tvistapp.com/privacy.htm") {
            ScreenVader.sharedVader.openSafariWithUrl(url: url, readerMode: true)
        }
    }
    
    @IBAction func didTapOnTermsOfService(_ sender: Any) {
        
        if let url = URL(string: "http://www.tvistapp.com/terms.html") {
            ScreenVader.sharedVader.openSafariWithUrl(url: url, readerMode: true)
        }
    }

}

extension UpgradePremiumViewController: IAPDataProtocol {
    func didFetchAvailableProducts() {
        AnalyticsVader.sharedVader.basicEvents(eventName: .UserUpgradeAvailableProductsLoaded)
        self.monthlyPriceLabel.text = IAPVader.sharedVader.priceForMonthlyPremium()
        self.yearlyPriceLabel.text = IAPVader.sharedVader.priceForYearlyPremium()
        
        productStartFetching(start: false)
    }
    
    func verificationSuccesfulForPayment(shouldDismiss: Bool) {
        productStartFetching(start: false)
        AnalyticsVader.sharedVader.basicEvents(eventName: .UserUpgradePaymentSuccessull)
        if shouldDismiss {
            
            self.navigationController?.dismiss(animated: true) {
                
            }
        }
    }
    
    func cancelled() {
        AnalyticsVader.sharedVader.basicEvents(eventName: .UserUpgradePaymentFailedCancelled)
        productStartFetching(start: false)
    }
}
