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
    @IBOutlet weak var addToEscapeButton: UIButton!
    
    @IBOutlet weak var creatorType: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var escapeTypeTag: UIImageView?
    
    
    @IBOutlet weak var hairlineHeightConstraint: NSLayoutConstraint!
    
    var userId = ""
    var isFollow = false
    var indexPath : IndexPath!
    
    var userHasActed:Bool = false
    
    weak var delegate:SearchTableViewCellProtocol?
    
    var data : SearchItems? {
        didSet{
            if let data = data, let escapeName = data.name, let searchType = data.searchType {
                
                var escapeTitleStr = escapeName
                if let year = data.year, searchType != .Books {
                    escapeTitleStr += " (\(year))"
                }
                itemNameLabel.text = escapeTitleStr
                itemSubtitleLabel.text = data.subTitle
                
                itemImage.downloadImageWithUrl(data.image , placeHolder: UIImage(named: "movie_placeholder"))
                
                var directorByStr = ""
                if let director = data.director{
                    directorByStr = director
                }
                
                self.userHasActed = data.isAddedOrFollow
                updateAddEditButtonStatus()
                
                var directedByStr = ""
                if data.searchType == .Movie {
                    directedByStr = EscapeCreatorType.Movie.rawValue+":"
                } else if data.searchType == .Books {
                   directedByStr = EscapeCreatorType.Books.rawValue+":"
                } else if data.searchType == .TvShows {
                    directedByStr = EscapeCreatorType.TvShows.rawValue+":"
                }
                
                let directedByString = SFUIAttributedText.regularAttributedTextForString("\(directedByStr)  ", size: 13, color: UIColor.textGrayColor())
                
                let directorString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(directorByStr)", size: 13, color: UIColor.textBlackColor()))
                
                let attributedString = NSMutableAttributedString()
                attributedString.append(directedByString)
                attributedString.append(directorString)
                creatorType.attributedText = attributedString
                
                
                
                if let escapeTypeTag = escapeTypeTag, let searchType = data.searchType {
                    escapeTypeTag.image = UIImage(named: "\(searchType.rawValue)_tag")
                }
            }
        }
    }
    
    func updateAddEditButtonStatus() {
        
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
//                    userFollowButton.followViewWithAnimate(false)
                }else{
//                    userFollowButton.unfollowViewWithAnimate(false)
                }
            }
        }
    }
    
    @IBAction func addToEscapeButtonClicked(_ sender: AnyObject) {
        self.delegate?.didTapOnCell(cell: self)
    }
    
    @IBAction func userFollowButtonClicked(_ sender: AnyObject) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        if let hairlineHeightConstraint = hairlineHeightConstraint {
            hairlineHeightConstraint.constant = 0.5
        }
        
    }
    
}

protocol SearchTableViewCellProtocol:class {
    func didTapOnCell(cell: SearchTableViewCell)
}
