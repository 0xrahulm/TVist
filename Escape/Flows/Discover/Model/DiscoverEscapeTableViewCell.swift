//
//  DiscoverEscapeTableViewCell.swift
//  Escape
//
//  Created by Ankit on 01/06/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol RemoveAddedEscapeCellProtocol : class {
    func removeAtIndex(indexPath : NSIndexPath)
}

class DiscoverEscapeTableViewCell: UITableViewCell {
    
    weak var removeAddedEscapeCellDelegate : RemoveAddedEscapeCellProtocol?
    weak var followButtonDiscoverDelegate : FollowerButtonProtocol?
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var hairlineHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var directorLabel: UILabel!
    
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var creatorType: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var peopleImage: UIImageView!
    
    @IBOutlet weak var peopleName: UILabel!
    @IBOutlet weak var peopleFollowerLabel: UILabel!
    
    @IBOutlet weak var escapeTypeTag: UIImageView?
    
    
    var userId = ""
    var isFollow = false
    
    var indexPath : NSIndexPath!
    
    var data : DiscoverItems? {
        didSet{
            if let data = data, let escapeName = data.name {
                var escapeTitleStr = escapeName
                if let year = data.year where data.discoverType != .Books {
                    escapeTitleStr += " (\(year))"
                }
                titleLabel.text = escapeTitleStr
                subtitleLabel.text = data.subtitle
                posterImage.downloadImageWithUrl(data.image , placeHolder: UIImage(named: "movie_placeholder"))
                
                if let director = data.director{
                    directorLabel.text = director
                    directorLabel.hidden = false
                }else{
                    directorLabel.hidden = true
                }
                
                if data.discoverType == .Movie{
                    creatorType.text = EscapeCreatorType.Movie.rawValue+":"
                }else if data.discoverType == .Books{
                    creatorType.text = EscapeCreatorType.Books.rawValue+":"
                }else if data.discoverType == .TvShows{
                    creatorType.text = EscapeCreatorType.TvShows.rawValue+":"
                }
                
                if let escapeTypeTag = escapeTypeTag, let discoveryType = data.discoverType {
                    escapeTypeTag.image = UIImage(named: "\(discoveryType.rawValue)_tag")
                }
                
            }
            
        }
    }
    
    var peopleData : DiscoverItems?{
        didSet{
            if let peopleData = peopleData{
                peopleName.text = peopleData.name
                peopleImage.downloadImageWithUrl(peopleData.image, placeHolder: UIImage(named: "profile_placeholder"))
                if let followersCount = peopleData.followers {
                    peopleFollowerLabel.text = "\(followersCount) Followers"
                }
                if let id = peopleData.id {
                    self.userId = id // remove optional from here
                }
                
                if peopleData.isFollow {
                    followButton.followViewWithAnimate(false)
                }else{
                    followButton.unfollowViewWithAnimate(false)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let hairlineHeightConstraint = hairlineHeightConstraint {
            hairlineHeightConstraint.constant = 0.5
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addButtonClicked(sender: AnyObject) {
        
        if let id = data?.id{
            if let type = data?.discoverType?.rawValue{
                
                let obj = AddToEscapeViewController()
                obj.addToEscapeDoneDelegate = self
                if let delegate = obj.addToEscapeDoneDelegate{
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenAddToEscapePopUp, queryParams: ["id" : id, "type" : type , "delegate" : delegate])
                }
                
                
            }
            
        }
        
        if let button = sender as? UIButton {
            button.popButtonAnimate()
        }
    }
    
    @IBAction func followButtonClicked(sender: AnyObject) {
        
        if isFollow {
            followButton.unfollowViewWithAnimate(true)
            isFollow = false
            UserDataProvider.sharedDataProvider.unfollowUser(self.userId)
        }else{
            followButton.followViewWithAnimate(true)
            isFollow = true
            UserDataProvider.sharedDataProvider.followUser(self.userId)
        }
        
        if self.followButtonDiscoverDelegate != nil{
            self.followButtonDiscoverDelegate?.changeLocalDataArray(self.indexPath, isFollow: isFollow)
        }
    }
}
extension DiscoverEscapeTableViewCell : AddToEscapeDoneProtocol{
    func doneButtonTapped() {
        if removeAddedEscapeCellDelegate != nil{
            removeAddedEscapeCellDelegate?.removeAtIndex(indexPath)
        }
    }
}
