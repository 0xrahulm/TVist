//
//  AppDelegate.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import UserNotifications
import Flurry_iOS_SDK
import Fabric
import Crashlytics
import AWSCognito
import Mixpanel
import iAd

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var initializedOnce: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        if let launchOptions = launchOptions, let remoteNotification = launchOptions[UIApplicationLaunchOptionsKey.remoteNotification] as? [String:Any] {
            if let deepLink = remoteNotification["deeplink"] as? String {
                ScreenVader.sharedVader.processDeepLink(deepLink)
            }
        }
        
        initializeScreenManager()
        Flurry.startSession("6J48C63N4JPPPNBMTRX4", withOptions: launchOptions)
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setGlobalAppearance()
        Fabric.with([Crashlytics.self, AWSCognito.self])
    
    
        //STAGING TOKENS
        var mixPanelToken = "eb64f6d436ffe1c7300fb55608da3848"
        
        //RELEASE TOKENS
        #if RELEASE
            mixPanelToken = "db252e600c2b8e71225d9956f7d715f9"
        #else
            
        #endif
        
        ACTConversionReporter.report(withConversionID: "852994885", label: "2FT0CIvFsHIQxdbelgM", value: "60.00", isRepeatable: false)
        
        Mixpanel.initialize(token: mixPanelToken)
        
        self.perform(#selector(AppDelegate.attributionDetails), with: nil, afterDelay: 50)
        
        return true
    }
    
    func attributionDetails() {
        ADClient.shared().requestAttributionDetails { (attributeDetails, error) in
            if error == nil {
                if let attributeDetails = attributeDetails, let v3Data = attributeDetails["Version3.1"] as? [String: AnyObject] {
                    if let attribution = v3Data["iad-attribution"] as? Bool {
                        if attribution {
                            var superProperties: Properties = [:]
                            
                            if let val = v3Data["iad-org-name"] as? MixpanelType  {
                                superProperties["iad-org-name"] = val
                            }
                            
                            if let val = v3Data["iad-campaign-id"] as? MixpanelType  {
                                superProperties["iad-campaign-id"] = val
                            }
                            
                            if let val = v3Data["iad-campaign-name"] as? MixpanelType  {
                                superProperties["iad-campaign-name"] = val
                            }
                            
                            if let val = v3Data["iad-conversion-date"] as? MixpanelType  {
                                superProperties["iad-conversion-date"] = val
                            }
                            
                            if let val = v3Data["iad-click-date"] as? MixpanelType  {
                                superProperties["iad-click-date"] = val
                            }
                            
                            if let val = v3Data["iad-adgroup-id"] as? MixpanelType  {
                                superProperties["iad-adgroup-id"] = val
                            }
                            
                            if let val = v3Data["iad-adgroup-name"] as? MixpanelType  {
                                superProperties["iad-adgroup-name"] = val
                            }
                            
                            if let val = v3Data["iad-keyword"] as? MixpanelType  {
                                superProperties["iad-keyword"] = val
                            }


                            Mixpanel.mainInstance().registerSuperProperties(superProperties)
                        } else {
                            
                            var superProperties:Properties = [:]
                            superProperties["campaign"] = "organic"
                            superProperties["media_source"] = "organic"
                            Mixpanel.mainInstance().registerSuperProperties(superProperties)
                        }
                    }
                }
            } else {
                var superProperties:Properties = [:]
                
                if let localizedDescription = error?.localizedDescription {
                    superProperties["attribution-error"] = localizedDescription
                }
                
                Mixpanel.mainInstance().registerSuperProperties(superProperties)
            }
        
        }
        
        ADClient.shared().add(toSegments: ["installed"], replaceExisting: true)
    }
    
    func onConversionDataReceived(_ installData: [AnyHashable : Any]!) {
        if let status = installData["af_status"] as? String {
            if status == "Non-organic" {
                var superProperties:Properties = [:]
                if let sourceID = installData["media_source"] as? MixpanelType  {
                    superProperties["media_source"] = sourceID
                }
                
                if let campaign = installData["campaign"] as? MixpanelType {
                    superProperties["campaign"] = campaign
                }
                if let keywords = installData["af_keywords"] as? MixpanelType {
                    superProperties["keywords"] = keywords
                }
                
                Mixpanel.mainInstance().registerSuperProperties(superProperties)
            } else if status == "Organic" {
            }
        }
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme, scheme == "mizzle" {
            ScreenVader.sharedVader.processDeepLink(url.absoluteString, shouldAddToPending: !self.initializedOnce)
        }
        
            
        let optionsStr:[String:Any] = [UIApplicationOpenURLOptionsKey.annotation.rawValue:options[UIApplicationOpenURLOptionsKey.annotation] ?? "", UIApplicationOpenURLOptionsKey.openInPlace.rawValue:options[UIApplicationOpenURLOptionsKey.openInPlace] ?? "", UIApplicationOpenURLOptionsKey.sourceApplication.rawValue:options[UIApplicationOpenURLOptionsKey.sourceApplication] ?? ""]
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
    func initializeScreenManager() {
        
        let storyboard = UIStoryboard(name: "ScreenManger", bundle: nil)
        
        let initialViewController = storyboard.instantiateInitialViewController()
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    // MARK :- Push Notification stack
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // MixPanel Notification Setup
        Mixpanel.mainInstance().people.addPushDeviceToken(deviceToken)
        
        // Convert token to string
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        UserDataProvider.sharedDataProvider.updateDeviceTokenIfRequired(pushToken: deviceTokenString)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Push notification received: \(userInfo)")
        
        if let deepLink = userInfo["deeplink"] as? String, application.applicationState != .active {
            ScreenVader.sharedVader.processDeepLink(deepLink)
        }
        
        Mixpanel.mainInstance().trackPushNotification(userInfo)
    }

    
    func setGlobalAppearance() {
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -500,vertical: 0), for: .default)
        
    }
    
    

}

