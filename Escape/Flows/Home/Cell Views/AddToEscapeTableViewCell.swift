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
    func commentTapped(_ indexPath : IndexPath)
}

class AddToEscapeTableViewCell: BaseStoryTableViewCell {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var creatorStatusLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var sharedLabelView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var sharedByImage: UIImageView!
    
    @IBOutlet weak var sharedByLabel: UILabel!
    @IBOutlet weak var escapeCollectionView: UICollectionView!
    
    var collectionDataArray : [EscapeDataItems] = []
    var indexPath : IndexPath?
    var storyId = ""
    
    weak var homeCommentDelegate : HomeCommentProtocol?
    
    var escapeItems : AddToEscapeCard?{
        didSet{
            
            escapeCollectionView.register(UINib(nibName: CellIdentifier.EscapeCollection.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.EscapeCollection.rawValue)
            
            
            if let escapeItems = escapeItems{
                
                if let id = escapeItems.id{
                    self.storyId = id
                }
                
                if let shareText = escapeItems.sharedText{
                    topConstraint.constant = 35
                    sharedByImage.image = IonIcons.image(withIcon: ion_android_share, size: 15, color: UIColor.textGrayColor())
                    sharedByLabel.text = shareText
                    sharedByImage.isHidden = false
                    sharedByLabel.isHidden = false
                    
                    let titleTapGesture = UITapGestureRecognizer(target: self, action: #selector(AddToEscapeTableViewCell.handletitleTapGesture(_:)))
                    sharedLabelView.addGestureRecognizer(titleTapGesture)
                    
                }else{
                    topConstraint.constant = 15
                    sharedByImage.isHidden = true
                    sharedByLabel.isHidden = true
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
                    
                  //  self.likesLabel.text = "\(escapeItems.likesCount) \(like)"
                }else{
                    //self.likesLabel.text = ""
                }
                
                if escapeItems.commentsCount > 0{
                    var comment = "comments"
                    if escapeItems.commentsCount == 1{
                        comment = "comment"
                    }
                    
                  //  self.commentLabel.text = "\(escapeItems.commentsCount) \(comment)"
                }else{
                  //  self.commentLabel.text = ""
                }
                
                if escapeItems.shareCount > 0{
                    var comment = "shares"
                    if escapeItems.shareCount == 1{
                        comment = "share"
                    }
                    
                  //  self.sharesLabel.text = "\(escapeItems.shareCount) \(comment)"
                }else{
                  //  self.sharesLabel.text = ""
                }
                
                if let timeStamp = escapeItems.timestamp{
                    self.createdTimeLabel.text = TimeUtility.getTimeStampForCard(Double(timeStamp))
                    self.createdTimeLabel.isHidden = false
                }else{
                    self.createdTimeLabel.text = "|"
                    self.createdTimeLabel.isHidden = true
                }
                
                if escapeItems.isLiked{
//                    likeButton.isSelected = true
                }else{
//                    likeButton.isSelected = false
                }
                
                if escapeItems.isShared{
//                    shareButton.isSelected = true
                }else{
//                    shareButton.isSelected = false
                }
                
                if escapeItems.isCommented{
//                    commentButton.isSelected = true
                }else{
//                    commentButton.isSelected = false
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
    @IBAction func likeTapped(_ sender: UIButton) {
        if likeButton.isSelected{
            likeButton.isSelected = false
            HomeDataProvider.sharedDataProvider.likeStory(false, storyId: storyId)
            
        }else{
            likeButton.isSelected = true
            HomeDataProvider.sharedDataProvider.likeStory(true, storyId: storyId)
            
        }
    }
    

    @IBAction func commentTapped(_ sender: UIButton) {
        
        if let delegate = homeCommentDelegate , let indexPath = self.indexPath{
            delegate.commentTapped(indexPath)
        }
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        if shareButton.isSelected{
            shareButton.isSelected = false
            HomeDataProvider.sharedDataProvider.shareStory(false, storyId: storyId)
        }else{
            shareButton.isSelected = true
            HomeDataProvider.sharedDataProvider.shareStory(true, storyId: storyId)
        }
    }
    
    func handletitleTapGesture(_ sender: UITapGestureRecognizer) {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenFollowers, queryParams: ["userType": UserType.sharedUsersOfStory.rawValue, "story_id" : storyId])
        
    }
    
    func constructAttributedString(_ escapeItems : AddToEscapeCard) -> NSMutableAttributedString{
        
        let attributedString = NSMutableAttributedString()
        
        var creatorName = ""
        var creatorId = ""
        if let name = escapeItems.creatorName,let id = escapeItems.createrId{
            creatorName = name
            creatorId = id
        }
        
        let nameString = NSMutableAttributedString(attributedString: SFUIAttributedText.mediumAttributedTextForString("\(creatorName) ", size: 15, color: UIColor.textBlackColor()))
        nameString.setAsLink(creatorName, linkURL: "escape://escape/user?user_id=\(creatorId)")
        attributedString.append(nameString)
        
        
        let verbString = SFUIAttributedText.regularAttributedTextForString("\(escapeItems.actionVerb) ", size: 14, color: UIColor.textGrayColor())
         attributedString.append(verbString)
        
        
        if escapeItems.items.count == 1{
            if let name = escapeItems.items[0].name, let id = escapeItems.items[0].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://escape/item?escape_id=\(id)")
                attributedString.append(escapeString)
                
            }
        }else if escapeItems.items.count == 2{
            
            if let name = escapeItems.items[0].name, let id = escapeItems.items[0].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://escape/item?escape_id=\(id)")
                attributedString.append(escapeString)
                
            }
            
            let prepositionString = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.append(prepositionString)
            
            if let name = escapeItems.items[1].name, let id = escapeItems.items[1].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://escape/item?escape_id=\(id)")
                attributedString.append(escapeString)
                
            }
        }else if escapeItems.items.count > 2{
            if let name = escapeItems.items[0].name, let id = escapeItems.items[0].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://escape/item?escape_id=\(id)")
                attributedString.append(escapeString)
                
            }
            let prepositionString1 = SFUIAttributedText.regularAttributedTextForString(", ", size: 14, color: UIColor.textBlackColor())
            attributedString.append(prepositionString1)
            
            if let name = escapeItems.items[1].name, let id = escapeItems.items[1].id{
                let escapeString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                escapeString.setAsLink(name, linkURL: "escape://escape/item?escape_id=\(id)")
                attributedString.append(escapeString)
                
            }
            
            let prepositionString2 = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.append(prepositionString2)
            
            if escapeItems.items.count > 3{
                let prepositionString3 = NSMutableAttributedString(attributedString:SFUIAttributedText.regularAttributedTextForString("\(escapeItems.items.count-2) others", size: 14, color: UIColor.textBlackColor()))
                prepositionString3.setAsLink("\(escapeItems.items.count-2) others", linkURL: "escape://openListingItems")
                attributedString.append(prepositionString3)
                
            }else{
                
                let prepositionString4 = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("1 other", size: 14, color: UIColor.textBlackColor()))
                prepositionString4.setAsLink("1 other", linkURL: "escape://escape/user?user_id=\(escapeItems.items[2].id)")
                attributedString.append(prepositionString4)
                
            }
            
        }
    
        
        let prepositionString = SFUIAttributedText.regularAttributedTextForString("\(escapeItems.preposition) ", size: 14, color: UIColor.textGrayColor())
        attributedString.append(prepositionString)
        
        
        if escapeItems.recommededUsers.count == 1{
            if let name = escapeItems.recommededUsers[0].name, let id = escapeItems.recommededUsers[0].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://escape/user?user_id=\(id)")
                attributedString.append(friendsString)
                
            }
        }else if escapeItems.recommededUsers.count == 2{
            
            if let name = escapeItems.recommededUsers[0].name, let id = escapeItems.recommededUsers[0].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://escape/user?user_id=\(id)")
                attributedString.append(friendsString)
                
            }
            
            let prepositionString = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.append(prepositionString)
            
            if let name = escapeItems.recommededUsers[1].name, let id = escapeItems.recommededUsers[1].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://escape/user?user_id=\(id)")
                attributedString.append(friendsString)
                
            }
        }else if escapeItems.recommededUsers.count > 2{
            if let name = escapeItems.recommededUsers[0].name, let id = escapeItems.recommededUsers[0].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://escape/user?user_id=\(id)")
                attributedString.append(friendsString)
                
            }
            let prepositionString1 = SFUIAttributedText.regularAttributedTextForString(", ", size: 14, color: UIColor.textBlackColor())
            attributedString.append(prepositionString1)
            
            if let name = escapeItems.recommededUsers[1].name, let id = escapeItems.recommededUsers[1].id{
                let friendsString = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("\(name) ", size: 14, color: UIColor.textBlackColor()))
                friendsString.setAsLink(name, linkURL: "escape://escape/user?user_id=\(id)")
                attributedString.append(friendsString)
                
            }
            
            let prepositionString2 = SFUIAttributedText.regularAttributedTextForString("and ", size: 14, color: UIColor.textGrayColor())
            attributedString.append(prepositionString2)
            
            if escapeItems.recommededUsers.count > 3{
                let prepositionString3 = NSMutableAttributedString(attributedString:SFUIAttributedText.regularAttributedTextForString("\(escapeItems.recommededUsers.count-2) others", size: 14, color: UIColor.textBlackColor()))
                prepositionString3.setAsLink("\(escapeItems.recommededUsers.count-2) others", linkURL: "escape://openListingFriends")
                attributedString.append(prepositionString3)
                
            }else{
                
                let prepositionString4 = NSMutableAttributedString(attributedString: SFUIAttributedText.regularAttributedTextForString("1 other", size: 14, color: UIColor.textBlackColor()))
                prepositionString4.setAsLink("1 other", linkURL: "escape://escape/user?user_id=\(escapeItems.recommededUsers[2].id)")
                attributedString.append(prepositionString4)
                
            }
            
        }
    
        return attributedString
        
    }

}
extension AddToEscapeTableViewCell : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionDataArray.count > indexPath.row{
             let data = collectionDataArray[indexPath.row]
            
                    var params : [String:Any] = [:]
                    if let id = data.id{
                        params["id"] = id
                    }
                    if let escapeType = data.escapeType{
                        params["escape_type"] = escapeType.rawValue
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.EscapeCollection.rawValue, for: indexPath) as! EscapeCollectionViewCell
        collectionCell.data = collectionDataArray[indexPath.row]
        
        return collectionCell
        
    }
}

extension AddToEscapeTableViewCell : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let urlString = URL.absoluteString
        
        ScreenVader.sharedVader.processDeepLink(urlString)
        
        return false
    }
}
extension NSMutableAttributedString {
    
    public func setAsLink(_ textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

