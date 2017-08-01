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
    @IBOutlet weak var trackButton: UIButton!
    
    @IBOutlet weak var creatorType: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var escapeTypeTag: UIImageView?
    
    
    @IBOutlet weak var hairlineHeightConstraint: NSLayoutConstraint!
    
    var userId = ""
    var searchPosition = "Guide"
    var isFollow = false
    var indexPath : IndexPath!
    
    var userHasActed:Bool = false
    
    weak var followButtonDiscoverDelegate : FollowerButtonProtocol?
    
    var escapeItem: EscapeItem? {
        didSet {
            if let data = self.escapeItem {
               
                itemNameLabel.text = data.name + " (\(data.year))"
                itemSubtitleLabel.text = nil
                if let image = data.posterImage {
                    
                    itemImage.downloadImageWithUrl(image, placeHolder: UIImage(named: "movie_placeholder"))
                }
                
                var directorByStr = ""
                if let director = data.createdBy{
                    directorByStr = director
                }
                
                self.userHasActed = data.hasActed
                self.selectionStyle = .none
                
                var directedByStr = ""
                if data.escapeTypeVal() == .Movie {
                    directedByStr = EscapeCreatorType.Movie.rawValue+" "
                } else if data.escapeTypeVal() == .Books {
                    directedByStr = EscapeCreatorType.Books.rawValue+" "
                } else if data.escapeTypeVal() == .TvShows {
                    directedByStr = EscapeCreatorType.TvShows.rawValue+" "
                }
                
                let directedByString = SFUIAttributedText.regularAttributedTextForString("\(directedByStr)  ", size: 13, color: UIColor.textGrayColor())
                
                let directorString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(directorByStr)", size: 13, color: UIColor.textBlackColor()))
                
                let attributedString = NSMutableAttributedString()
                attributedString.append(directedByString)
                attributedString.append(directorString)
                creatorType.attributedText = attributedString
                
                
                trackButton.setTitle(nil, for: .normal)
                
                trackButton.setImage(IonIcons.image(withIcon: ion_android_time, size: 25, color: UIColor.white), for: .normal)
                trackButton.setImage(IonIcons.image(withIcon: ion_android_done_all, size: 25, color: UIColor.white), for: .selected)
                
                updateTrackButton(newState: self.userHasActed)
                
                if let escapeTypeTag = escapeTypeTag {
                    escapeTypeTag.image = UIImage(named: "\(data.escapeType)_tag")
                }
                
            }
        }
    }
    
    
    
    func updateTrackButton(newState: Bool) {
        
        trackButton.isSelected = newState
        if newState {
            trackButton.backgroundColor = UIColor.defaultCTAColor()
        } else {
            trackButton.backgroundColor = UIColor.defaultTintColor()
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
    
    @IBAction func addToEscapeButtonClicked(_ sender: AnyObject) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.TrackSearchedItem, properties: ["Position":searchPosition])
        toggleButtonState()
//        if let data = data, let escapeId = data.id, let searchType = data.searchType, let escapeName = data.name {
//            
//            var paramsToPass: [String:Any] = ["escape_id" : escapeId, "escape_type":searchType.rawValue, "escape_name": escapeName, "delegate" : self]
//            
//            if let createdBy = data.director {
//                paramsToPass["createdBy"] = createdBy
//            }
//            
//            if let imageUri = data.image {
//                paramsToPass["escape_image"] = imageUri
//            }
//            
//            if self.userHasActed {
//                ScreenVader.sharedVader.performScreenManagerAction(.OpenEditEscapePopUp, queryParams: paramsToPass)
//            } else {
//                ScreenVader.sharedVader.performScreenManagerAction(.OpenAddToEscapePopUp, queryParams: paramsToPass)
//            }
//        }
    }
    
    
    func toggleButtonState() {
        trackButton.popButtonAnimate()
        let newState = !trackButton.isSelected
        if !newState {
            if let itemName = escapeItem?.name {
                
                let alert = UIAlertController(title: "Are you sure?", message: "Tracking for \(itemName) is already setup, would you like to remove it?", preferredStyle: .alert)
                
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    
                    
                    if let item = self.escapeItem {
                        item.hasActed = newState
                        
                            TrackingDataProvider.shared.removeTrackingFor(escapeId: item.id)
                        
                        self.updateTrackButton(newState: newState)
                    }
                })
                
                alert.addAction(removeAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                
                ScreenVader.sharedVader.showAlert(alert: alert)
            }
        } else {
            if let item = escapeItem {
                item.hasActed = newState
                TrackingDataProvider.shared.addTrackingFor(escapeId: item.id)
                
                updateTrackButton(newState: newState)
            }
        }
    }
    
    
    @IBAction func userFollowButtonClicked(_ sender: AnyObject) {
        
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
        self.userHasActed = true
        updateTrackButton(newState: self.userHasActed)
    }
}
extension SearchTableViewCell : EditEscapeProtocol{
    func didDeleteEscape() {
        self.userHasActed = false
        updateTrackButton(newState: self.userHasActed)
    }
}
