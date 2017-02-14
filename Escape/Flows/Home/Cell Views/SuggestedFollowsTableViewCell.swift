//
//  SuggestedFollowsTableViewCell.swift
//  Escape
//
//  Created by Ankit on 09/02/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

protocol ChangeDataForFollosProtocol : class{
    func changeDataArray(dataIndexPath : NSIndexPath, followerIndexPath : NSIndexPath, isFollow : Bool)
}

class SuggestedFollowsTableViewCell: BaseStoryTableViewCell {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    
    var collectionDataArray : [MyAccountItems] = []
    weak var changeDataDelegate : ChangeDataForFollosProtocol?
    var dataIndexPath : NSIndexPath?
    
    var data : SuggestedFollowsCard?{
        didSet{
            suggestedCollectionView.registerNib(UINib(nibName: CellIdentifier.SuggestedPeopleCollection.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.SuggestedPeopleCollection.rawValue)

            if let data = data{

                if let title = data.title{
                     titleLabel.text = title
                    titleLabel.text = "Discover new people"
                }else{
                    titleLabel.text = ""
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
        collectionCell.changePeopleDelegate = self
        collectionCell.indexPath = indexPath
        collectionCell.data = collectionDataArray[indexPath.row]
        return collectionCell
    }
    
}
extension SuggestedFollowsTableViewCell : ChangePeopleCollectionProtocol{
    func changePeopleData(indexPath: NSIndexPath, isFollow : Bool){
        if let changeDataDelegate = changeDataDelegate, let dataIndexPath = dataIndexPath{
            changeDataDelegate.changeDataArray(dataIndexPath, followerIndexPath : indexPath, isFollow : isFollow)
        }
    }
    
}
