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
    @IBOutlet weak var followAllButton: UIButton!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var friendItems : FBFriendCard?{
        didSet{
            if let friendItems  = friendItems{
                if let title = friendItems.title{
                    cellTitleLabel.text = title
                }
                
                if friendItems.friends.count > 3{
                    
                image1.downloadImageWithUrl(friendItems.friends[0].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                image2.downloadImageWithUrl(friendItems.friends[1].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                image3.downloadImageWithUrl(friendItems.friends[2].profilePicture , placeHolder: UIImage(named: "profile_placeholder"))
                    
                    
                }
            }
        }
    }
    
    @IBAction func seeAllTapped(sender: AnyObject) {
    }

    @IBAction func followAllTapped(sender: AnyObject) {
    }
}
