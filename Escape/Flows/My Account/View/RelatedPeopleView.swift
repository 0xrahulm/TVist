//
//  RelatedPeopleView.swift
//  Escape
//
//  Created by Rahul Meena on 08/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

protocol RelatedPeopleViewAllTapProtocol:class {
    
    func viewAllTappedInRelatedPeople()
}

class RelatedPeopleView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var collectionDataArray : [MyAccountItems] = []
    
    weak var viewAllTapDelegate: RelatedPeopleViewAllTapProtocol?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.register(UINib(nibName: CellIdentifier.SuggestedPeopleCollection.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.SuggestedPeopleCollection.rawValue)
    }
    
    @IBAction func viewAllTapped(sender: UIButton) {
        if let delegate = self.viewAllTapDelegate {
            delegate.viewAllTappedInRelatedPeople()
        }
    }
    
    
    func getRelatedPeopleData(escapeId: String) {
        activityIndicator.startAnimating()
        MyAccountDataProvider.sharedDataProvider.relatedPeopleDelegate = self
        MyAccountDataProvider.sharedDataProvider.getRelatedPeople(escapeId: escapeId, page: nil)
        self.isHidden = false
    }

}

extension RelatedPeopleView: RelatedPeopleProtocol {
    func receivedRelatedPeople(_ relatedPeople: [MyAccountItems], page: Int?) {
        self.collectionDataArray = relatedPeople
        self.collectionView.reloadData()
        self.activityIndicator.stopAnimating()
        
    }
    
    func failedToReceivedData() {
        self.activityIndicator.stopAnimating()
    }
}


extension RelatedPeopleView : UICollectionViewDelegate{
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

extension RelatedPeopleView : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.SuggestedPeopleCollection.rawValue, for: indexPath) as! SuggestedPeopleCollectionViewCell
        collectionCell.data = collectionDataArray[indexPath.row]
        
        return collectionCell
        
    }
    
}
