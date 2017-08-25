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
    @IBOutlet weak var actionCountLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var signInButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButtonWidthConstraint: NSLayoutConstraint!
    
    var viewType: String = "Tracking"
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fetchDataFromRealm()
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
        
        self.actionNameLabel.text = viewType
        var actionCount = 0
        
        if viewType == "Tracking" {
            actionCount = tracksCount
        } else {
            actionCount = escapesCount
        }
        
        if actionCount > 0 {
            if actionCountLabel != nil {
             
                actionCountLabel.text = "\(actionCount)"
            }
        } else {
            if viewType == "Tracking" {
                actionNameLabel.text = "No tracking data"
            } else {
                actionNameLabel.text = "No watchlist data"
            }
            
            if actionCountLabel != nil {
                
                actionCountLabel.text = nil
            }
        }
        
        if userType != "g" {
            self.signInButtonWidthConstraint.constant = 0
            self.signInButtonHeightConstraint.constant = 0
            self.layoutIfNeeded()
        } else {
            self.actionNameLabel.text = "Register to sync your data"
            
            if actionCountLabel != nil {
                actionCountLabel.text = nil
            }
        }
    }
    
    @IBAction func signUpButtonTapped() {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SignUpNowClick, properties: ["fromView": viewType])
        ScreenVader.sharedVader.performScreenManagerAction(.OpenSignupView, queryParams: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
