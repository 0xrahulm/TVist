//
//  SuggestedPeopleCollectionViewCell.swift
//  Escape
//
//  Created by Ankit on 09/02/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

protocol ChangePeopleCollectionProtocol : class{
    func changePeopleData(indexPath: NSIndexPath, isFollow : Bool)
}

class SuggestedPeopleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    weak var changePeopleDelegate : ChangePeopleCollectionProtocol?
    var isFollow = false
    var userId : String?
    var indexPath : NSIndexPath?
    
    var data : MyAccountItems?{
        didSet{
            if let data = data{
                if let id = data.id{
                    self.userId = id
                }
                if let image = data.profilePicture{
                    self.cellImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "profile_placeholder"))
                    
                }else{
                    self.cellImage.image = UIImage.getImageWithColor(UIColor.placeholderColor(), size: cellImage.frame.size)
                }
               
                nameLabel.text = "\(data.firstName) \(data.lastName)"
                followersLabel.text = "\(data.followers) Followers"
                
                self.outerView.layer.borderWidth = 1
                self.outerView.layer.borderColor = UIColor.placeholderColor().CGColor
                self.outerView.layer.cornerRadius = 5
                
                isFollow =  data.isFollow
                if data.isFollow {
                    followButton.followViewWithAnimate(false)
                }else{
                    followButton.unfollowViewWithAnimate(false)
                }
            }
        }
    }
    
    
    
    @IBAction func followButtonTapped(sender: UIButton) {
        if isFollow {
            followButton.unfollowViewWithAnimate(true)
            isFollow = false
            if let id = userId{
                UserDataProvider.sharedDataProvider.unfollowUser(id)
            }
            
        }else{
            followButton.followViewWithAnimate(true)
            isFollow = true
            if let id = userId{
                UserDataProvider.sharedDataProvider.followUser(id)
            }
        }
        
        if let delegate = changePeopleDelegate, let indexPath = indexPath{
            delegate.changePeopleData(indexPath, isFollow: isFollow)
        }
        
    }
    
}
