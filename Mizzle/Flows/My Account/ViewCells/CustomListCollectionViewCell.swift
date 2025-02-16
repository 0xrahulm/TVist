//
//  CustomListCollectionViewCell.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol PrimaryCTATapProtocol: class {
    func didTapOnPrimaryCTA(collectionView: UICollectionView, cell: UICollectionViewCell)
}

class CustomListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ctaButton: UIButton!
    
    @IBOutlet weak var airdateLabel: UILabel!
    
    @IBOutlet weak var maxRatingLabel: UILabel!
    @IBOutlet weak var ratedImage: UIImageView!
    
    @IBOutlet weak var ratingView: UIView!
    weak var primaryCTADelegate: PrimaryCTATapProtocol?
    
    weak var parentCollectionView: UICollectionView?
    
    var trackPosition: String!
    
    var mediaItem : ListingMediaItem? {
        didSet{
            if let dataItems = mediaItem {
                titleLabel.text = dataItems.constructedTitle()
                itemImage.downloadImageWithUrl(dataItems.mediaItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
                
                
                if ctaButton != nil {
                    
                    ctaButton.setImage(UIImage(named:"WatchlistAddIcon"), for: .normal)
                    ctaButton.setImage(UIImage(named:"EditIconWhite"), for: .selected)
                    
                    ctaButton.setTitle("Add", for: .normal)
                    ctaButton.setTitle("Edit", for: .selected)
                }
                
                hideTrackerButton()
                
                if let _ = dataItems.airdate {
                    self.airdateLabel.text = dataItems.airtime!
                    ratingView.isHidden = true
                } else {
                    self.airdateLabel.text = nil
                    if let rating = dataItems.mediaItem.rating {
                        
                        if rating.characters.count > 0 {
                            
                            ratingLabel.text = rating
                            ratingView.isHidden = false
                        }else{
                            ratingView.isHidden = true
                            
                        }
                    }
                }
                
                
            }
        }
    }
    
    var dataItems : EscapeItem? {
        didSet{
            if let dataItems = dataItems{
                titleLabel.text = dataItems.name
                itemImage.downloadImageWithUrl(dataItems.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
                let year = dataItems.year
                
                if ctaButton != nil {
                    
                    ctaButton.setImage(UIImage(named:"WatchlistAddIcon"), for: .normal)
                    ctaButton.setImage(IonIcons.image(withIcon: ion_edit, size: 16, color: UIColor.white), for: .selected)
                    ctaButton.setTitle("Add", for: .normal)
                    ctaButton.setTitle("Edit", for: .selected)
                }
                
                
                
                if year.characters.count > 0 {

//                    yearLabel.isHidden = false
                }else{
//                    yearLabel.isHidden = true
                }
                
                if let airtime = dataItems.nextAirtime, let airDate = airtime.airDate {
                    self.airdateLabel.text = airDate
                    ratingView.isHidden = true
                } else {
                    self.airdateLabel.text = nil
                    let rating = dataItems.rating
                    if rating.characters.count > 0 {
                        
                        ratingLabel.text = rating
                        ratingView.isHidden = false
                        
                    }else{
                        ratingView.isHidden = true
                    }
                }
                if ctaButton != nil {
                    updateTrackButton(newState: dataItems.hasActed)
                }
            }
        }
    }
    
    
    @IBAction func addButtonTapped(sender: UIButton) {
        
        ctaButton.popButtonAnimate()
        
        if let item = dataItems {
            if ctaButton.isSelected {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.EditButtonTap, properties: ["escapeName": item.name, "escapeType": item.escapeType, "Position":trackPosition])
            } else {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.AddButtonTap, properties: ["escapeName": item.name, "escapeType": item.escapeType, "Position":trackPosition])
            }
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openAddToWatchlistView, queryParams: ["mediaItem": item, "delegate": self])
        }
        
        
        if let primaryCTADelegate = self.primaryCTADelegate, let collectionView = self.parentCollectionView {
            primaryCTADelegate.didTapOnPrimaryCTA(collectionView: collectionView, cell: self)
        }
        
//        let newState = !ctaButton.isSelected
//        if !newState {
//            if let itemName = dataItems?.name {
//                
//                let alert = UIAlertController(title: "Are you sure?", message: "Tracking for \(itemName) is already setup, would you like to remove it?", preferredStyle: .alert)
//                
//                
//                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
//                    
//                    
//                    if let item = self.dataItems {
//                        item.isAlertSet = newState
//                        AnalyticsVader.sharedVader.undoTrack(escapeName: item.name, escapeId: item.id, escapeType: item.escapeType, position: self.trackPosition)
//                        TrackingDataProvider.shared.removeTrackingFor(escapeId: item.id)
//                        self.updateTrackButton(newState: newState)
//                    }
//                })
//                
//                alert.addAction(removeAction)
//                
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                
//                alert.addAction(cancelAction)
//                
//                ScreenVader.sharedVader.showAlert(alert: alert)
//            }
//        } else {
//        }
        
    }
    
    func updateTrackButton(newState: Bool) {
        
        ctaButton.isSelected = newState
        ctaButton.backgroundColor = UIColor.styleGuideActionButtonBlue()
        
    }
    
    func hideTrackerButton() {
        
        self.layoutIfNeeded()
    }
    
    func popTheImage() {
        
        UIView.animate(withDuration: 0.07,
                                   animations: {
                                    self.itemImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.07, animations: {
                                        self.itemImage.transform = CGAffineTransform.identity
                                    })
        })
    }
    
}

extension CustomListCollectionViewCell: AddToWatchlistPopupProtocol {
    func addToWatchlistDone(isAlertSet: Bool) {
        if let item = self.dataItems {
            item.isAlertSet = isAlertSet
            item.hasActed = true
        }
        self.ctaButton.isSelected = true
    }
}
