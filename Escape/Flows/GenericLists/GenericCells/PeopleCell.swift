//
//  PeopleCell.swift
//  Escape
//
//  Created by Rahul Meena on 29/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class PeopleCell: NormalCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followUnfollowButton: UIButton!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    var isFollow = false
    
    var userId:String!
    var indexPath : IndexPath?
    
    weak var followButtonDelegate : FollowerButtonProtocol?
    
    var loggable:Bool = false
    
    var accountItem: MyAccountItems? {
        didSet {
            attachData()
        }
    }
    
    func attachData() {
        if let accountItem = self.accountItem {
            fullNameLabel.text = "\(accountItem.firstName) \(accountItem.lastName)"
            profilePictureView.downloadImageWithUrl(accountItem.profilePicture, placeHolder: UIImage(named: "profile_placeholder"))
            
            followersCountLabel.text = "\(accountItem.followers.intValue) Followers"
            
            if let id = self.accountItem?.id {
                self.userId = id // remove optional from here
            }
            if !self.loggable {
                
                self.isFollow = accountItem.isFollow
                
                if accountItem.isFollow {
                    followUnfollowButton.followViewWithAnimate(false)
                }else{
                    followUnfollowButton.unfollowViewWithAnimate(false)
                }
            } else {
                followUnfollowButton.isHidden = true
                if accountItem.loggedInUsing == .Email {
                    followersCountLabel.text = "Tap to login with password"
                } else if accountItem.loggedInUsing == .Facebook {
                    followersCountLabel.text = "Tap to login using facebook"
                } else if accountItem.loggedInUsing == .Guest {
                    followersCountLabel.text = "Tap to create a new user"
                }
            }
        }
    }

    @IBAction func followButtonClicked(_ sender: AnyObject) {
        
        if isFollow {
            followUnfollowButton.unfollowViewWithAnimate(true)
            isFollow = false
            UserDataProvider.sharedDataProvider.unfollowUser(self.userId)
        } else {
            followUnfollowButton.followViewWithAnimate(true)
            isFollow = true
            UserDataProvider.sharedDataProvider.followUser(self.userId)
        }
        
        if self.followButtonDelegate != nil{
            self.followButtonDelegate?.changeLocalDataArray(self.indexPath, isFollow: isFollow)
        }
    }
}
