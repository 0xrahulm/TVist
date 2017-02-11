//
//  SuggestedFollowsTableViewCell.swift
//  Escape
//
//  Created by Ankit on 09/02/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class SuggestedFollowsTableViewCell: BaseStoryTableViewCell {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var creatorStatusLabel: UILabel!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    
    var collectionDataArray : [MyAccountItems] = []
    
    var data : SuggestedFollowsCard?{
        didSet{
            suggestedCollectionView.registerNib(UINib(nibName: CellIdentifier.SuggestedPeopleCollection.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.SuggestedPeopleCollection.rawValue)
            if let data = data{
                let nameString = NSMutableAttributedString(attributedString: SFUIAttributedText.mediumAttributedTextForString("Escape", size: 15, color: UIColor.textBlackColor()))
                
                titleTextView.attributedText = nameString
                
                if let status = data.title{
                    creatorStatusLabel.text = status
                }else{
                    creatorStatusLabel.text = ""
                }
                
                if let timeStamp = data.timestamp{
                    self.createdTimeLabel.text = TimeUtility.getTimeStampForCard(Double(timeStamp))
                    self.createdTimeLabel.hidden = false
                }else{
                    self.createdTimeLabel.text = "|"
                    self.createdTimeLabel.hidden = true
                }
                
                self.collectionDataArray = data.suggestedFollows
                suggestedCollectionView.reloadData()
                
            }
            
        }
    }
}
extension SuggestedFollowsTableViewCell : UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionDataArray.count > indexPath.row{
            let data = collectionDataArray[indexPath.row]
            
            var params : [String:AnyObject] = [:]
            if let id = data.id{
                params["user_id"] = id
            }
            
            ScreenVader.sharedVader.performScreenManagerAction(.OpenUserAccount, queryParams: params)
            
        }
    }
    

}
extension SuggestedFollowsTableViewCell : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.SuggestedPeopleCollection.rawValue, forIndexPath: indexPath) as! SuggestedPeopleCollectionViewCell
        collectionCell.data = collectionDataArray[indexPath.row]
        
        return collectionCell
        
    }
    
}
