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
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var actionNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var signInButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButtonWidthConstraint: NSLayoutConstraint!
    
    var viewType: String = "Tracking"
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fetchDataFromRealm()
        
        
        // Get user details early on so the data is available before
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailView.fetchDataFromRealm), name: Notification.Name(rawValue: NotificationObservers.UserDetailsDataObserver.rawValue), object: nil)
        MyAccountDataProvider.sharedDataProvider.getUserDetails(nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func fetchDataFromRealm() {
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            
            pushUpUserData(user.firstName, lastName: user.lastName, profilePicture: user.profilePicture, escapesCount: user.escape_count, tracksCount: user.track_count, userType: user.userType)
            
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
                self.actionNameLabel.text = "Tracking \(actionCount)"
            } else if viewType == "Home" || viewType == "Watchlist" {
                self.actionNameLabel.text = "Watchlist \(actionCount)"
            }
        } else {
            if viewType == "Tracking" {
                actionNameLabel.text = "No Tracking"
            } else if viewType == "Watchlist" || viewType == "Home" {
                actionNameLabel.text = "No Watchlist"
            }
        }
        
        if userType != "g" {
            self.signInButtonWidthConstraint.constant = 0
            self.signInButtonHeightConstraint.constant = 0
            self.layoutIfNeeded()
        } else {
            self.actionNameLabel.text = "Register to use across all your devices"
        }
    }
    
    @IBAction func signUpButtonTapped() {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SignUpNowClick, properties: ["fromView": viewType])
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSignupView, queryParams: nil)
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
