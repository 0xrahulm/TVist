//
//  UserDetailView.swift
//  Mizzle
//
//  Created by Rahul Meena on 22/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class UserDetailView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var membershipButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var premiumBadgeView: UIImageView!
    
    @IBOutlet weak var signInButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButtonWidthConstraint: NSLayoutConstraint!
    
    var viewType: String = "User"
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fetchDataFromRealm()
        
        
        // Get user details early on so the data is available before
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailView.fetchDataFromRealm), name: Notification.Name(rawValue: NotificationObservers.UserDetailsDataObserver.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailView.profileDetailsChanged(_:)), name: NSNotification.Name(NotificationObservers.ProfileImageChangesObserver.rawValue), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func profileDetailsChanged(_ notification: Notification) {
        if let image = notification.object as? UIImage {
            self.profileImageView.image = image
        }
    }
    
    @objc func fetchDataFromRealm() {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            
            pushUpUserData(user.firstName, lastName: user.lastName, profilePicture: user.profilePicture, escapesCount: user.escape_count, tracksCount: user.track_count, userType: user.userType)
            
            self.premiumBadgeView.isHidden = !user.isPremium()
            self.membershipButton.backgroundColor = UIColor.styleGuideButtonRed()
            var membershipButtonTitle = "Upgrade Now"
            if user.isPremium() {
                membershipButtonTitle = "Premium"
                self.membershipButton.backgroundColor = UIColor.styleGuidePremiumOrange()
            } else if user.userTypeEnum() == .Guest {
                membershipButtonTitle = "Sign Up Now"
            }
            
            self.membershipButton.setTitle("  \(membershipButtonTitle)  ", for: .normal)
            
        }
    }
    
    
    func pushUpUserData(_ firstName: String, lastName: String?, profilePicture: String?, escapesCount:Int, tracksCount: Int, userType: String) {
        if let lastName = lastName, lastName.characters.count > 0 {
            self.fullNameLabel.text = "\(firstName) \(lastName)"
        } else {
            self.fullNameLabel.text = firstName
        }
        
        profileImageView.downloadImageWithUrl(profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
        
        var actionCount = 0
        
        if viewType == "Tracking" {
            actionCount = tracksCount
        } else {
            actionCount = escapesCount
        }
        
        if actionCount > 0 {
            
            if viewType == "Tracking" {
//                self.actionNameLabel.text = "Tracking \(actionCount)"
            } else if viewType == "Home" || viewType == "Watchlist" {
//                self.actionNameLabel.text = "Watchlist \(actionCount)"
            }
        } else {
            if viewType == "Tracking" {
//                actionNameLabel.text = "No Tracking"
            } else if viewType == "Watchlist" || viewType == "Home" {
//                actionNameLabel.text = "No Watchlist"
            }
        }
        
        if userType != "g" {
        } else {
//            self.actionNameLabel.text = "Register to use across all your devices"
        }
    }
    
    @IBAction func profileButtonTapped() {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            if user.isPremium() {
                ScreenVader.sharedVader.performUniversalScreenManagerAction(.openProfileEditView, queryParams: nil)
            } else if user.userTypeEnum() == .Guest {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UserSignUpNowClick)
                ScreenVader.sharedVader.performUniversalScreenManagerAction(.openSignUpView, queryParams: nil)
            } else {
                ScreenVader.sharedVader.performUniversalScreenManagerAction(.openTVistPremiumView, queryParams: nil)
            }
        }
    }
    
    @IBAction func signUpButtonTapped() {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UserSignUpNowClick)
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openSignUpView, queryParams: nil)
    }
    
    @IBAction func settingsButtonTapped() {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UserSettingButtonTap)
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openUserSettingsView, queryParams: ["fromView": viewType])
    }
    
    
    @IBAction func profileImageHotspotTap(sender: UIButton) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeProfileImageHotspotClick)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
