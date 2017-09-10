//
//  SuggestedPeopleCollectionViewCell.swift
//  Escape
//
//  Created by Ankit on 09/02/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class SuggestedPeopleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    var isFollow: Bool = false
    var userId: String?
    var data : MyAccountItems?{
        didSet{
            if let data = data{
                if let image = data.profilePicture{
                    self.cellImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "profile_placeholder"))
                    
                }else{
                    self.cellImage.image = UIImage.getImageWithColor(UIColor.placeholderColor(), size: cellImage.frame.size)
                }
               
                nameLabel.text = "\(data.firstName) \(data.lastName)"
                followersLabel.text = "\(data.followers) Followers"
                
                self.outerView.layer.borderWidth = 1
                self.outerView.layer.borderColor = UIColor.placeholderColor().cgColor
                self.outerView.layer.cornerRadius = 5
                
                self.isFollow = data.isFollow
                self.userId = data.id
                
                if data.isFollow {
                    followButton.followViewWithAnimate(false)
                }else{
                    followButton.unfollowViewWithAnimate(false)
                }
            }
        }
    }
    
    
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        if let userId = self.userId {
            
            if isFollow {
                followButton.unfollowViewWithAnimate(true)
                isFollow = false
                UserDataProvider.sharedDataProvider.unfollowUser(userId)
            } else {
                followButton.followViewWithAnimate(true)
                isFollow = true
                UserDataProvider.sharedDataProvider.followUser(userId)
            }
        }
    }
    
}
