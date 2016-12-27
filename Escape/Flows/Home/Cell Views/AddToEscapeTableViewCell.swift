//
//  AddToEscapeTableViewCell.swift
//  Escape
//
//  Created by Ankit on 06/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import ionicons

protocol HomeCommentProtocol : class {
    func commentTapped(indexPath : NSIndexPath)
}

class AddToEscapeTableViewCell: BaseStoryTableViewCell {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var creatorStatusLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var sharedByImage: UIImageView!
    
    @IBOutlet weak var sharedByLabel: UILabel!
    @IBOutlet weak var escapeCollectionView: UICollectionView!
    
    var collectionDataArray : [EscapeDataItems] = []
    var indexPath : NSIndexPath?
    
    weak var homeCommentDelegate : HomeCommentProtocol?
    
    var escapeItems : AddToEscapeCard?{
        didSet{
            if let escapeItems = escapeItems{
                
                escapeCollectionView.registerNib(UINib(nibName: CellIdentifier.EscapeCollection.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.EscapeCollection.rawValue)
                
                topConstraint.constant = 35
                sharedByImage.image = IonIcons.imageWithIcon(ion_android_share, size: 15, color: UIColor.textGrayColor())
                sharedByLabel.text = "Sachin Gupta shared"
                
                if let image = escapeItems.creatorImage{
                    self.creatorImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "profile_placeholder"))
                    
                }else{
                    self.creatorImage.image = UIImage.getImageWithColor(UIColor.placeholderColor(), size: creatorImage.frame.size)
                }
                
                var recommededUser = ""
                
                if let title = escapeItems.title{
                    if escapeItems.recommededUsers.count > 0{
                       
                        var i = 0
                        for item in escapeItems.recommededUsers{
                            if i != 0{
                                recommededUser = item + ", " + recommededUser
                            }else{
                                recommededUser = item
                            }
                            i = i + 1
                        }
                        
                        sharedByImage.image = IonIcons.imageWithIcon(ion_android_favorite, size: 15, color: UIColor.textGrayColor())
                        sharedByLabel.text = "Vivek Kishore liked"
                        
                    }
                    //self.titleLabel.text = "\(creatorName) \(title) \(recommededUser)"
                    
                }else{
                    //self.titleLabel.text = "\(creatorName)"
                }
                
                if let status = escapeItems.creatorStatus{
                    self.creatorStatusLabel.text = status.firstCharUppercaseFirst
                }else{
                    self.creatorStatusLabel.text = ""
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
                
                if let timeStamp = escapeItems.timestamp{
                    self.createdTimeLabel.text = TimeUtility.getTimeStampForCard(Double(timeStamp))
                    self.createdTimeLabel.hidden = false
                }else{
                    self.createdTimeLabel.text = "|"
                    self.createdTimeLabel.hidden = true
                }
                
                self.collectionDataArray = escapeItems.items
                escapeCollectionView.reloadData()
 
                let nameString = NSMutableAttributedString(attributedString: SFUIAttributedText.mediumAttributedTextForString("\(escapeItems.creatorName!) ", size: 15, color: UIColor.textBlackColor()))
                nameString.setAsLink(escapeItems.creatorName!, linkURL: "http://google.com")
                
                let verbString = SFUIAttributedText.regularAttributedTextForString("is watching ", size: 14, color: UIColor.textGrayColor())
                
                
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("Inception ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink("Inception", linkURL: "stackoverflow")
                
                let withString = SFUIAttributedText.regularAttributedTextForString("with ", size: 14, color: UIColor.textGrayColor())
                
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("Rahul Meena", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink("Rahul Meena", linkURL: "http://facebook.com")
                
                let attributedString = NSMutableAttributedString()
                attributedString.appendAttributedString(nameString)
                attributedString.appendAttributedString(verbString)
                attributedString.appendAttributedString(escapeString)
                attributedString.appendAttributedString(withString)
                attributedString.appendAttributedString(friendsString)
                self.titleTextView.delegate = self
                self.titleTextView.attributedText = attributedString
                self.titleTextView.linkTextAttributes  = [NSForegroundColorAttributeName: UIColor.textBlackColor()]
                
            }
        }
    }
    @IBAction func likeTapped(sender: UIButton) {
        if likeButton.selected{
            likeButton.selected = false
        }else{
            likeButton.selected = true
        }
    }
    

    @IBAction func commentTapped(sender: UIButton) {
        
        if let delegate = homeCommentDelegate , indexPath = self.indexPath{
            delegate.commentTapped(indexPath)
        }
    }
    
    @IBAction func shareTapped(sender: UIButton) {
        if shareButton.selected{
            shareButton.selected = false
        }else{
            shareButton.selected = true
        }
    }

}
extension AddToEscapeTableViewCell : UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionDataArray.count > indexPath.row{
             let data = collectionDataArray[indexPath.row]
            
                    var params : [String:AnyObject] = [:]
                    if let id = data.id{
                        params["id"] = id
                    }
                    if let escapeType = data.escapeType{
                        params["escapeType"] = escapeType.rawValue
                    }
                    if let name = data.name{
                        params["name"] = name
                    }
                    if let image = data.image{
                        params["image"] = image
                    }
                    
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)

        }
    }

}
extension AddToEscapeTableViewCell : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.EscapeCollection.rawValue, forIndexPath: indexPath) as! EscapeCollectionViewCell
        collectionCell.data = collectionDataArray[indexPath.row]
        
        return collectionCell
        
    }
}

extension AddToEscapeTableViewCell : UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        print(URL.absoluteString!)
        
        return false
    }
}
extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.rangeOfString(textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

