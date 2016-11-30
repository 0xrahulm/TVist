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
    var indexPath : NSIndexPath?
    
    weak var followButtonDelegate : FollowerButtonProtocol?

    @IBAction func followButtonClicked(sender: AnyObject) {
        
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
