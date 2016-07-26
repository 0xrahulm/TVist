//
//  FollowersTableViewCell.swift
//  Escape
//
//  Created by Ankit on 06/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {
    
    var isFollow = false
    var userId = ""
    
 
    @IBOutlet weak var followerImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!

    @IBAction func followButtonClicked(sender: AnyObject) {
        
        if isFollow {
            followButton.setTitle("  + Follow  ", forState: .Normal)
            followButton.backgroundColor = UIColor.whiteColor()
            followButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            followButton.layer.borderColor = UIColor.blueColor().CGColor
            followButton.layer.borderWidth = 1.0
            isFollow = false

            UserDataProvider.sharedDataProvider.unfollowUser(self.userId)
        }else{
            followButton.setTitle("  Following  ", forState: .Normal)
            followButton.backgroundColor = UIColor.greenColor()
            followButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            followButton.layer.borderWidth = 0.0
            isFollow = true
            
            UserDataProvider.sharedDataProvider.followUser(self.userId)
        }
        
        
        
        UIView.animateWithDuration(0.1 ,
                                   animations: {
                                    self.followButton.transform = CGAffineTransformMakeScale(1.3, 1.3)
            },
                                   completion: { finish in
                                    UIView.animateWithDuration(0.1){
                                        self.followButton.transform = CGAffineTransformIdentity
                                    }
        })
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
