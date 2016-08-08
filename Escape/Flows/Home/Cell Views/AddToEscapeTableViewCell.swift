//
//  AddToEscapeTableViewCell.swift
//  Escape
//
//  Created by Ankit on 06/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class AddToEscapeTableViewCell: BaseStoryTableViewCell {
    
    @IBOutlet weak var creatorImage: UIImageView!
    
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var creatorStatusLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var escapeCollectionView: UICollectionView!
    
    var collectionDataArray : [EscapeDataItems] = []
    
    
    var escapeItems : AddToEscapeCard?{
        didSet{
            if let escapeItems = escapeItems{
                
                if let name = escapeItems.creatorName{
                    self.creatorNameLabel.text = name
                    self.creatorNameLabel.hidden = false
                }else{
                    self.creatorNameLabel.hidden = true
                }
                
                if let image = escapeItems.creatorImage{
                    self.creatorImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "profile_placeholder"))
                    self.creatorImage.hidden = false
                }else{
                    self.creatorImage.hidden = true
                }
                if let title = escapeItems.title{
                    self.titleLabel.text = title
                    
                }else{
                    self.titleLabel.text = ""
                }
                if let status = escapeItems.creatorStatus{
                    self.creatorStatusLabel.text = status
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
                if let timeStamp = escapeItems.timestamp{
                    self.createdTimeLabel.text = TimeUtility.getTimeStampForCard(Double(timeStamp))
                }else{
                    self.createdTimeLabel.text = ""
                }
                self.collectionDataArray = escapeItems.items
                escapeCollectionView.reloadData()
            }
        }
    }


}
extension AddToEscapeTableViewCell : UICollectionViewDelegate{
    
}
extension AddToEscapeTableViewCell : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("escapeCollectionCellIdentifier", forIndexPath: indexPath) as! EscapeCollectionViewCell
        let data = collectionDataArray[indexPath.row]
        collectionCell.escapeImage.downloadImageWithUrl(data.image , placeHolder: UIImage(named: "movie_placeholder"))
        return collectionCell
        
    }
}
