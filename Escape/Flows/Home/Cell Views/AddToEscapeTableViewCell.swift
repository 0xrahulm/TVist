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
            
            escapeCollectionView.registerNib(UINib(nibName: CellIdentifier.EscapeCollection.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.EscapeCollection.rawValue)
            
            
            if let escapeItems = escapeItems{
                if let shareText = escapeItems.sharedText{
                    topConstraint.constant = 35
                    sharedByImage.image = IonIcons.imageWithIcon(ion_android_share, size: 15, color: UIColor.textGrayColor())
                    sharedByLabel.text = shareText
                    sharedByImage.hidden = false
                    sharedByLabel.hidden = false
                }else{
                    topConstraint.constant = 15
                    sharedByImage.hidden = true
                    sharedByLabel.hidden = true
                }
                
                
                if let image = escapeItems.creatorImage{
                    self.creatorImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "profile_placeholder"))
                    
                }else{
                    self.creatorImage.image = UIImage.getImageWithColor(UIColor.placeholderColor(), size: creatorImage.frame.size)
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
                
                if escapeItems.isLiked{
                    likeButton.selected = true
                }else{
                    likeButton.selected = false
                }
                
                if escapeItems.isShared{
                    shareButton.selected = true
                }else{
                    shareButton.selected = false
                }
                
                if escapeItems.isCommented{
                    commentButton.selected = true
                }else{
                    commentButton.selected = false
                }
                
                self.collectionDataArray = escapeItems.items
                escapeCollectionView.reloadData()
                
                let attributedString = constructAttributedString(escapeItems)
                
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
    
    func constructAttributedString(escapeItems : AddToEscapeCard) -> NSMutableAttributedString{
        
        let attributedString = NSMutableAttributedString()
        
        var creatorName = ""
        var creatorId = ""
        if let name = escapeItems.creatorName,let id = escapeItems.createrId{
            creatorName = name
            creatorId = id
        }
        
        let nameString = NSMutableAttributedString(attributedString: SFUIAttributedText.mediumAttributedTextForString("\(creatorName) ", size: 15, color: UIColor.textBlackColor()))
        nameString.setAsLink(creatorName, linkURL: "escape://user?id=\(creatorId)")
        attributedString.appendAttributedString(nameString)
        
        
        let verbString = SFUIAttributedText.regularAttributedTextForString("\(escapeItems.actionVerb) ", size: 14, color: UIColor.textGrayColor())
         attributedString.appendAttributedString(verbString)
        
        
        if escapeItems.items.count == 1{
            if let name = escapeItems.items[0].name, let id = escapeItems.items[0].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://item?id=\(id)")
                attributedString.appendAttributedString(escapeString)
                
            }
        }else if escapeItems.items.count == 2{
            
            if let name = escapeItems.items[0].name, let id = escapeItems.items[0].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://item?id=\(id)")
                attributedString.appendAttributedString(escapeString)
                
            }
            
            let prepositionString = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.appendAttributedString(prepositionString)
            
            if let name = escapeItems.items[1].name, let id = escapeItems.items[1].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://item?id=\(id)")
                attributedString.appendAttributedString(escapeString)
                
            }
        }else if escapeItems.items.count > 2{
            if let name = escapeItems.items[0].name, let id = escapeItems.items[0].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://item?id=\(id)")
                attributedString.appendAttributedString(escapeString)
                
            }
            let prepositionString1 = SFUIAttributedText.regularAttributedTextForString(", ", size: 14, color: UIColor.textBlackColor())
            attributedString.appendAttributedString(prepositionString1)
            
            if let name = escapeItems.items[1].name, let id = escapeItems.items[1].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://item?id=\(id)")
                attributedString.appendAttributedString(escapeString)
                
            }
            
            let prepositionString2 = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.appendAttributedString(prepositionString2)
            
            if escapeItems.items.count > 3{
                let prepositionString3 = NSMutableAttributedString(attributedString:SFUIAttributedText.regularAttributedTextForString("\(escapeItems.items.count-2) others", size: 14, color: UIColor.textBlackColor()))
                prepositionString3.setAsLink("\(escapeItems.items.count-2) others", linkURL: "escape://openListingItems")
                attributedString.appendAttributedString(prepositionString3)
                
            }else{
                
                let prepositionString4 = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("1 other", size: 14, color: UIColor.textBlackColor()))
                prepositionString4.setAsLink("1 other", linkURL: "escape://user?id=\(escapeItems.items[2].id)")
                attributedString.appendAttributedString(prepositionString4)
                
            }
            
        }
    
        
        let prepositionString = SFUIAttributedText.regularAttributedTextForString("\(escapeItems.preposition) ", size: 14, color: UIColor.textGrayColor())
        attributedString.appendAttributedString(prepositionString)
        
        
        if escapeItems.recommededUsers.count == 1{
            if let name = escapeItems.recommededUsers[0].name, let id = escapeItems.recommededUsers[0].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://user?id=\(id)")
                attributedString.appendAttributedString(friendsString)
                
            }
        }else if escapeItems.recommededUsers.count == 2{
            
            if let name = escapeItems.recommededUsers[0].name, let id = escapeItems.recommededUsers[0].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://user?id=\(id)")
                attributedString.appendAttributedString(friendsString)
                
            }
            
            let prepositionString = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.appendAttributedString(prepositionString)
            
            if let name = escapeItems.recommededUsers[1].name, let id = escapeItems.recommededUsers[1].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://user?id=\(id)")
                attributedString.appendAttributedString(friendsString)
                
            }
        }else if escapeItems.recommededUsers.count > 2{
            if let name = escapeItems.recommededUsers[0].name, let id = escapeItems.recommededUsers[0].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://user?id=\(id)")
                attributedString.appendAttributedString(friendsString)
                
            }
            let prepositionString1 = SFUIAttributedText.regularAttributedTextForString(", ", size: 14, color: UIColor.textBlackColor())
            attributedString.appendAttributedString(prepositionString1)
            
            if let name = escapeItems.recommededUsers[1].name, let id = escapeItems.recommededUsers[1].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://user?id=\(id)")
                attributedString.appendAttributedString(friendsString)
                
            }
            
            let prepositionString2 = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.appendAttributedString(prepositionString2)
            
            if escapeItems.recommededUsers.count > 3{
                let prepositionString3 = NSMutableAttributedString(attributedString:SFUIAttributedText.regularAttributedTextForString("\(escapeItems.recommededUsers.count-2) others", size: 14, color: UIColor.textBlackColor()))
                prepositionString3.setAsLink("\(escapeItems.recommededUsers.count-2) others", linkURL: "escape://openListingFriends")
                attributedString.appendAttributedString(prepositionString3)
                
            }else{
                
                let prepositionString4 = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("1 other", size: 14, color: UIColor.textBlackColor()))
                prepositionString4.setAsLink("1 other", linkURL: "escape://user?id=\(escapeItems.recommededUsers[2].id)")
                attributedString.appendAttributedString(prepositionString4)
                
            }
            
        }
    
        return attributedString
        
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

