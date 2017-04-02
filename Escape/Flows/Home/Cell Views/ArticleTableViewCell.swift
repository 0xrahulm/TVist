//
//  ArticleTableViewCell.swift
//  Escape
//
//  Created by Ankit on 02/10/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class ArticleTableViewCell: BaseStoryTableViewCell {

    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var creatorStatusLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleStatus: UILabel!
    @IBOutlet weak var articleSource: UILabel!
    
    var indexPath : IndexPath?
    weak var homeCommentDelegate : HomeCommentProtocol?
    
    var data : ArticleCard?{
        didSet{
            if let escapeItems = data{
                
                if let name = escapeItems.creatorName{
                    self.titleLabel.text = name
                }else{
                    self.titleLabel.text = "Escape"
                }
                
                if let image = escapeItems.creatorImage{
                    self.creatorImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "profile_placeholder"))
//                    self.creatorImage.layer.borderWidth = 1
//                    self.creatorImage.layer.borderColor = UIColor.darkPlaceholderColor().CGColor
                    
                    
                }else{
                    
                    self.creatorImage.image = UIImage.getImageWithColor(UIColor.placeholderColor(), size: creatorImage.frame.size)
                }
                
        
                if escapeItems.likesCount > 0{
                    var like = "likes"
                    if escapeItems.likesCount == 1{
                        like = "like"
                    }
                    
                    self.likesLabel.text = "\(escapeItems.likesCount) \(like)"
                }else{
                    self.likesLabel.text = ""
                }
                
                if escapeItems.commentsCount > 0{
                    var comment = "comments"
                    if escapeItems.commentsCount == 1{
                        comment = "comment"
                    }
                    
                    self.commentLabel.text = "\(escapeItems.commentsCount) \(comment)"
                }else{
                    self.commentLabel.text = ""
                }
                
                if escapeItems.shareCount > 0{
                    var comment = "shares"
                    if escapeItems.shareCount == 1{
                        comment = "share"
                    }
                    
                    self.sharesLabel.text = "\(escapeItems.shareCount) \(comment)"
                }else{
                    self.sharesLabel.text = ""
                }
                
                if let title = escapeItems.title{
                    self.creatorStatusLabel.text  = title
                }else{
                    self.creatorStatusLabel.text  = ""
                }
                
                if let timeStamp = escapeItems.timestamp{
                    self.createdTimeLabel.text = TimeUtility.getTimeStampForCard(Double(timeStamp))
                    self.createdTimeLabel.isHidden = false
                }else{
                    self.createdTimeLabel.text = "|"
                    self.createdTimeLabel.isHidden = true
                }
               
                if let articleImge = escapeItems.articleImage{
                    
                    self.articleImage.downloadImageWithUrl(articleImge, placeHolder: UIImage.getImageWithColor(UIColor.placeholderColor(), size: articleImage.frame.size))
                    self.articleImage.isHidden = false
                }else{
                    self.articleImage.image = UIImage.getImageWithColor(UIColor.placeholderColor(), size: articleImage.frame.size)
                }
                
                if let source = escapeItems.creatorName{
                    self.articleSource.text = "Source : \(source)"
                }else{
                    self.articleSource.text = ""
                }
                
                if let title = escapeItems.articleTitle{
                    self.articleStatus.text = title
                }else{
                    self.articleStatus.text = ""
                }
                
                self.articleView.layer.borderWidth = 1
                self.articleView.layer.borderColor = UIColor.darkPlaceholderColor().cgColor
                //self.articleView.layer.cornerRadius = 5
                
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func likesTapped(_ sender: UIButton) {
    }
    
    @IBAction func commentTapped(_ sender: UIButton) {
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
    }

}
