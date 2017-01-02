//
//  FBFriendsTableViewCell.swift
//  Escape
//
//  Created by Ankit on 04/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class FBFriendsTableViewCell: BaseStoryTableViewCell {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    
    @IBOutlet weak var image2Width: NSLayoutConstraint!
    @IBOutlet weak var image3Width: NSLayoutConstraint!
    @IBOutlet weak var image4Width: NSLayoutConstraint!
    @IBOutlet weak var image5Width: NSLayoutConstraint!
    
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var followView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followView.backgroundColor = UIColor.clearColor()
        followView.layer.cornerRadius = 3
        followView.layer.borderWidth = 1
        followView.layer.borderColor = UIColor.facebookThemeColor().CGColor
    }
    
    var friendItems : FBFriendCard?{
        didSet{
            if let friendItems  = friendItems{
                //if let title = friendItems.title{
                    cellTitleLabel.text = "Your \(friendItems.friends.count) Facebook friends have already joined Escape."
                //}
                
                image2Width.constant = 0
                image3Width.constant = 0
                image4Width.constant = 0
                image5Width.constant = 0
                
                if friendItems.friends.count > 0{
                    
                    image1.downloadImageWithUrl(friendItems.friends[0].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                }
                if friendItems.friends.count > 1{
                    image2.downloadImageWithUrl(friendItems.friends[1].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                    image2Width.constant = 45
                    
                }
                if friendItems.friends.count > 2{
                    image3.downloadImageWithUrl(friendItems.friends[2].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                    image3Width.constant = 45
                    
                }
                if friendItems.friends.count > 3{
                    image4.downloadImageWithUrl(friendItems.friends[3].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                    image4Width.constant = 45
                    
                }
                if friendItems.friends.count > 4{
                    image5.downloadImageWithUrl(friendItems.friends[4].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                    image5Width.constant = 45
                    
                }
                
                
            }
        }
    }
    
    @IBAction func seeAllTapped(sender: UIButton) {
    }
    
    
}

