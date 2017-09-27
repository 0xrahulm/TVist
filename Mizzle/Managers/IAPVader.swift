//
//  IAPVader.swift
//  TVist
//
//  Created by Rahul Meena on 15/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import StoreKit

protocol IAPDataProtocol: class {
    func didFetchAvailableProducts()
    func verificationSuccesfulForPayment(shouldDismiss: Bool)
    func cancelled()
}

class IAPVader: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let kMonthlyInAppPurchaseIdentifier = "com.ardourlabs.Mizzle.TVistPremiumMonthly"
    
    let kYearlyInAppPurchaseIdentifier = "com.ardourlabs.Mizzle.TVistPremiumYearly"
    
    static let sharedVader = IAPVader()
    
    var productsRequest: SKProductsRequest!
    
    var subscriptions = [Subscription]()
    
    weak var delegate: IAPDataProtocol?
    
    var processingSubscriptionPurchase: Subscription?
    var processingSubscriptionRestore: Subscription?
    
    override init() {
        super.init()
        
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        
        if self.subscriptions.count > 0 {
            self.delegate?.didFetchAvailableProducts()
        } else {
            
            
            // Put here your IAP Products ID's
            let productIdentifiers = NSSet(objects:
                kMonthlyInAppPurchaseIdentifier,
                                           kYearlyInAppPurchaseIdentifier
            )
            
            
            productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            subscriptions = response.products.map { Subscription(product: $0) }
            
            self.delegate?.didFetchAvailableProducts()
        }
    }
    
    func monthlyPremiumProduct() -> Subscription? {
        for eachSubscription in subscriptions {
            if eachSubscription.productIdentifier == kMonthlyInAppPurchaseIdentifier {
                return eachSubscription
            }
        }
        
        return nil
    }
    
    func yearlyPremiumProduct() -> Subscription? {
        
        for eachSubscription in subscriptions {
            if eachSubscription.productIdentifier == kYearlyInAppPurchaseIdentifier {
                return eachSubscription
            }
        }
        return nil
    }
    
    func priceForYearlyPremium() -> String? {
        if let yearlyPremium = yearlyPremiumProduct() {
            return yearlyPremium.formattedPrice
        }
        return nil
    }
    
    func priceForMonthlyPremium() -> String? {
        
        if let monthlyPremium = monthlyPremiumProduct() {
            return monthlyPremium.formattedPrice
        }
        return nil
    }
    
    func purchaseMonthlyPremium() {
        if let monthlyProduct = monthlyPremiumProduct() {
            purchaseSubscription(subscription: monthlyProduct)
        }
    }
    
    func getSubscriptionByIdentifier(identifier: String) -> Subscription? {
        for subscription in self.subscriptions {
            if identifier == subscription.productIdentifier {
                return subscription
            }
        }
        
        return nil
    }
    
    func purchaseYearlyPremium() {
        if let yearlyProduct = yearlyPremiumProduct() {
            purchaseSubscription(subscription: yearlyProduct)
        }
    }
    
    func purchaseSubscription(subscription: Subscription) {
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: subscription.product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            self.processingSubscriptionPurchase = subscription
        } else {
            failedWithMessage(message: "Purchases are disabled on your device.")
        }
    }
    
    func failedWithMessage(message: String) {
        
        var title = "Upgrade failed"
        
        if let _ = self.processingSubscriptionRestore {
            title = "Restore failed"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            
            if let _ = self.processingSubscriptionRestore {
                self.restorePuchases()
            }
            
            if let subscription = self.processingSubscriptionPurchase {
                
                self.purchaseSubscription(subscription: subscription)
            }
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(retryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            
        })
        alert.addAction(cancelAction)
        
        ScreenVader.sharedVader.showAlert(alert: alert)
    }
    
    func restorePuchases() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handlePurchasedState(for: transaction, in: queue)
                break
            case .restored:
                handleRestoredState(for: transaction, in: queue)
                break
            case .failed:
                handleFailedState(for: transaction, in: queue)
                break
            case .deferred:
                handleDeferredState(for: transaction, in: queue)
                break
            case .purchasing:
                handlePurchasingState(for: transaction, in: queue)
                break
            }
        }
    }
    
    func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User is attempting to purchase product id: \(transaction.payment.productIdentifier)")
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User purchased product id: \(transaction.payment.productIdentifier)")
        
        queue.finishTransaction(transaction)
        verifyReceiptData()
    }
    
    func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase restored for product id: \(transaction.payment.productIdentifier)")
        self.processingSubscriptionRestore = self.getSubscriptionByIdentifier(identifier: transaction.payment.productIdentifier)
        queue.finishTransaction(transaction)
        
        verifyReceiptData()
    }
    
    func verifyReceiptData() {
        
        if let loadedReceipt = loadReceipt() {
            let receiptString = loadedReceipt.base64EncodedString()
            
            MyAccountDataProvider.sharedDataProvider.verifyItunesReceipt(receiptData: receiptString)
        }
    }
    
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase failed for product id: \(transaction.payment.productIdentifier)")
        self.delegate?.cancelled()
    }
    
    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
        self.delegate?.cancelled()
    }
    
    var hasReceiptData: Bool {
        return loadReceipt() != nil
    }
    
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    func succesfullyVerified(shouldDismiss: Bool) {
        self.delegate?.verificationSuccesfulForPayment(shouldDismiss: shouldDismiss)
    }
}
