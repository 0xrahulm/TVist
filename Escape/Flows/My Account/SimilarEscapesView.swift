//
//  SimilarEscapesView.swift
//  Escape
//
//  Created by Rahul Meena on 07/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

protocol SimilarEscapesViewAllTapProtocol:class {
    
    func viewAllTappedIn()
}

class SimilarEscapesView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var similarEscapes:[EscapeItem] = []
    
    weak var viewAllTapDelegate: SimilarEscapesViewAllTapProtocol?
    
    @IBAction func viewAllTapped(sender: UIButton) {
        if let delegate = self.viewAllTapDelegate {
            delegate.viewAllTappedIn()
        }
    }
    
    func getSimilarEscapesData(escapeId: String, escapeType: EscapeType?) {
        activityIndicator.startAnimating()
        MyAccountDataProvider.sharedDataProvider.similarEscapesDelegate = self
        MyAccountDataProvider.sharedDataProvider.getSimilarEscapes(escapeId: escapeId, escapeType: escapeType)
        self.isHidden = false
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension SimilarEscapesView: SimilarEscapesProtocol {
    func receivedSimilarEscapes(_ escapeData: [EscapeItem]) {
        self.similarEscapes = escapeData
        self.collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func failedToReceivedData() {
        activityIndicator.stopAnimating()
    }
}

extension SimilarEscapesView : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let escapeItemCell = collectionView.cellForItem(at: indexPath) as? CustomListCollectionViewCell {
            
            escapeItemCell.popTheImage()
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var params : [String:AnyObject] = [:]
                
        params["escapeItem"] = similarEscapes[indexPath.row]
                
        ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return similarEscapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewBasicCell", for: indexPath) as! CustomListCollectionViewCell
        
        cell.dataItems = similarEscapes[indexPath.row]
        
        return cell
    }
}
