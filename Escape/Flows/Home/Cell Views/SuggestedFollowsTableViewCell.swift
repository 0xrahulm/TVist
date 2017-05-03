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
            suggestedCollectionView.register(UINib(nibName: CellIdentifier.SuggestedPeopleCollection.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.SuggestedPeopleCollection.rawValue)
            if let data = data{
                let nameString = NSMutableAttributedString(attributedString: SFUIAttributedText.mediumAttributedTextForString("Mizzle", size: 15, color: UIColor.textBlackColor()))
                
//                titleTextView.attributedText = nameString
//                
//                if let status = data.title{
//                    creatorStatusLabel.text = status
//                }else{
//                    creatorStatusLabel.text = ""
//                }
//                
//                if let timeStamp = data.timestamp{
//                    self.createdTimeLabel.text = TimeUtility.getTimeStampForCard(Double(timeStamp))
//                    self.createdTimeLabel.isHidden = false
//                }else{
//                    self.createdTimeLabel.text = "|"
//                    self.createdTimeLabel.isHidden = true
//                }
                
                self.collectionDataArray = data.suggestedFollows
                suggestedCollectionView.reloadData()
                
            }
            
        }
    }
}
extension SuggestedFollowsTableViewCell : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionDataArray.count > indexPath.row{
            let data = collectionDataArray[indexPath.row]
            
            var params : [String:Any] = [:]
            if let id = data.id{
                params["user_id"] = id
            }
            
            ScreenVader.sharedVader.performScreenManagerAction(.OpenUserAccount, queryParams: params)
            
        }
    }
    

}
extension SuggestedFollowsTableViewCell : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.SuggestedPeopleCollection.rawValue, for: indexPath) as! SuggestedPeopleCollectionViewCell
        collectionCell.data = collectionDataArray[indexPath.row]
        
        return collectionCell
        
    }
    
}
