//
//  FollowersTableViewCell.swift
//  Escape
//
//  Created by Ankit on 06/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol FollowerButtonProtocol : class {
    func changeLocalDataArray(_ indexPath : IndexPath? , isFollow : Bool)
}

class FollowersTableViewCell: UITableViewCell {
    
    var isFollow = false
    var userId = ""
    var indexPath : IndexPath?
    
    weak var followButtonDelegate : FollowerButtonProtocol?
    
    @IBOutlet weak var followerImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var hairlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var friendsCheckImage: UIImageView!

    @IBAction func followButtonClicked(_ sender: AnyObject) {
        
        if isFollow {
            followButton.unfollowViewWithAnimate(true)
            isFollow = false
            UserDataProvider.sharedDataProvider.unfollowUser(self.userId)
        } else {
            followButton.followViewWithAnimate(true)
            isFollow = true
            UserDataProvider.sharedDataProvider.followUser(self.userId)
        }
        
        if self.followButtonDelegate != nil{
            self.followButtonDelegate?.changeLocalDataArray(self.indexPath, isFollow: isFollow)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let hairlineHeightConstraint = hairlineHeightConstraint {
            hairlineHeightConstraint.constant = 0.5
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
