//
//  SearchTableViewCell.swift
//  Escape
//
//  Created by Ankit on 17/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var loadingViewLabel: UILabel!
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFollowButton: UIButton!
    
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemSubtitleLabel: UILabel!
    @IBOutlet weak var itemCreatorLabel: UILabel!
    @IBOutlet weak var addToEscapeButton: UIButton!
    
    @IBOutlet weak var creatorType: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var escapeTypeTag: UIImageView?
    
    
    @IBOutlet weak var hairlineHeightConstraint: NSLayoutConstraint!
    
    var userId = ""
    var isFollow = false
    var indexPath : NSIndexPath!
    weak var followButtonDiscoverDelegate : FollowerButtonProtocol?
    
    var data : SearchItems? {
        didSet{
            if let data = data, let escapeName = data.name, let searchType = data.searchType {
                
                var escapeTitleStr = escapeName
                if let year = data.year where searchType != .Books {
                    escapeTitleStr += " (\(year))"
                }
                itemNameLabel.text = escapeTitleStr
                itemSubtitleLabel.text = data.subTitle
                
                itemImage.downloadImageWithUrl(data.image , placeHolder: UIImage(named: "movie_placeholder"))
                if let director = data.director{
                    itemCreatorLabel.text = director
                    itemCreatorLabel.hidden = false
                }else{
                    itemCreatorLabel.hidden = true
                }
                if data.isAddedOrFollow{
                    addToEscapeButton.hidden = true
                }else{
                    addToEscapeButton.hidden = false
                }
                
                
                if data.searchType == .Movie {
                    creatorType.text = EscapeCreatorType.Movie.rawValue+":"
                } else if data.searchType == .Books {
                    creatorType.text = EscapeCreatorType.Books.rawValue+":"
                } else if data.searchType == .TvShows {
                    creatorType.text = EscapeCreatorType.TvShows.rawValue+":"
                }
                
                
                
                if let escapeTypeTag = escapeTypeTag, let searchType = data.searchType {
                    escapeTypeTag.image = UIImage(named: "\(searchType.rawValue)_tag")
                }
            }
        }
    }
    
    var peopleData : SearchItems?{
        didSet{
            if let peopleData = peopleData{
                userNameLabel.text = peopleData.name
                userImage.downloadImageWithUrl(peopleData.image, placeHolder: UIImage(named: "profile_placeholder"))
                
                if let id = peopleData.id{
                    self.userId = id // remove optional from here
                }
                if peopleData.isAddedOrFollow{
                    userFollowButton.followViewWithAnimate(false)
                }else{
                    userFollowButton.unfollowViewWithAnimate(false)
                }
            }
        }
    }
    
    @IBAction func addToEscapeButtonClicked(sender: AnyObject) {
        
        if let data = data{
            
            let obj = AddToEscapeViewController()
            obj.addToEscapeDoneDelegate = self
            
            if let delegate = obj.addToEscapeDoneDelegate{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenAddToEscapePopUp, queryParams: ["data" : data, "delegate" : delegate])
            }
        }
    }
    
    @IBAction func userFollowButtonClicked(sender: AnyObject) {
        
        if isFollow {
            userFollowButton.unfollowViewWithAnimate(true)
            isFollow = false
            UserDataProvider.sharedDataProvider.unfollowUser(self.userId)
        }else{
            userFollowButton.followViewWithAnimate(true)
            isFollow = true
            UserDataProvider.sharedDataProvider.followUser(self.userId)
        }
        
        if self.followButtonDiscoverDelegate != nil{
            self.followButtonDiscoverDelegate?.changeLocalDataArray(self.indexPath, isFollow: isFollow)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let hairlineHeightConstraint = hairlineHeightConstraint {
            hairlineHeightConstraint.constant = 0.5
        }
        
    }
    
}
extension SearchTableViewCell : AddToEscapeDoneProtocol{
    func doneButtonTapped() {
        
    }
}
