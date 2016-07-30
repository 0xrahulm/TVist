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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var directorLabel: UILabel!
    
    @IBOutlet weak var ctaButton: UIButton!
    
    @IBOutlet weak var distinguishView: UIView!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var peopleImage: UIImageView!
    
    @IBOutlet weak var peopleName: UILabel!
    @IBOutlet weak var peopleFollowerLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var userId = ""
    var isFollow = false
    
    var indexPath : NSIndexPath!
    
    var data : DiscoverItems? {
        didSet{
            if let data = data{
                titleLabel.text = data.name
                posterImage.downloadImageWithUrl(data.image , placeHolder: UIImage(named: "movie_placeholder"))
                if let director = data.director{
                    directorLabel.text = director
                    directorLabel.hidden = false
                }else{
                    directorLabel.hidden = true
                }
                if data.discoverType == .Movie{
                    distinguishView.backgroundColor = UIColor.colorForMovie()
                }else if data.discoverType == .Books{
                    distinguishView.backgroundColor = UIColor.colorForBook()
                }else if data.discoverType == .TvShows{
                    distinguishView.backgroundColor = UIColor.colorForTvShow()
                }else if data.discoverType == .People{
                    distinguishView.backgroundColor = UIColor.colorForPeople()
                }
                
            }
            
        }
    }
    
    var peopleData : DiscoverItems?{
        didSet{
            if let peopleData = peopleData{
                peopleName.text = peopleData.name
                peopleImage.downloadImageWithUrl(peopleData.image, placeHolder: UIImage(named: "profile_placeholder"))
                peopleFollowerLabel.text = "22 Followers"
                if let id = peopleData.id{
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
        // Initialization code
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
