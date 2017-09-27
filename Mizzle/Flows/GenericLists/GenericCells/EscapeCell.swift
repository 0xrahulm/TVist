//
//  EscapeCell.swift
//  Escape
//
//  Created by Rahul Meena on 29/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class EscapeCell: NormalCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var ratingLabel:UILabel!
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var airtimeLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    
    @IBOutlet weak var ctaButton: UIButton!
    
    
    var userHasActed:Bool = false
    var trackPosition: String!
    
    var escapeItem: EscapeItem? {
        didSet {
            attachData()
        }
    }
    
    func attachData() {
        
        if let escapeItem = escapeItem {
            
            titleLabel.text = escapeItem.name
            
            let year = escapeItem.year
            if year.characters.count > 0 && escapeItem.escapeTypeVal() != .Books {
                yearLabel.text = year
            }
            posterImageView.downloadImageWithUrl(escapeItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
            
            
            if let nextAirtime = escapeItem.nextAirtime {
                self.airtimeLabel.text = nextAirtime.dayText()+", "+nextAirtime.airTime
                
                
                self.episodeLabel.text = nextAirtime.episodeString
            } else {
                self.airtimeLabel.text = nil
                self.episodeLabel.text = nil
            }
            
//            if let nextAirtime = escapeItem.nextAirtime {
//                var airText:String = ""
//                if let airDate = nextAirtime.airDate {
//                    airText += "\(airDate) "
//                }
//                airText += "\(nextAirtime.airTime!)"
//
//                if let channelName = nextAirtime.channelName {
//                    airText += " on \(channelName)"
//                }
//                self.airtimeLabel.text = airText
//            } else {
//                self.airtimeLabel.text = "Not airing in next 7 days."
//            }
            self.ratingView.isHidden = (escapeItem.rating == "")
            self.ratingLabel.text = escapeItem.rating
            
            self.userHasActed = escapeItem.hasActed
            
            if ctaButton != nil {
                
                ctaButton.setImage(UIImage(named:"WatchlistAddIcon"), for: .normal)
                ctaButton.setImage(UIImage(named:"EditIconWhite"), for: .selected)
                
                ctaButton.setTitle("Add", for: .normal)
                ctaButton.setTitle("Edit", for: .selected)
            }
            
            updateAddEditButton()
            
        }
    }
    
    
    
    @IBAction func trackButtonTapped(sender: UIButton) {
        
        toggleButtonState()
    }
    
    func toggleButtonState() {
        ctaButton.popButtonAnimate()
        let newState = !ctaButton.isSelected
        if !newState {
            if let itemName = escapeItem?.name {
                
                let alert = UIAlertController(title: "Are you sure?", message: "Tracking for \(itemName) is already setup, would you like to remove it?", preferredStyle: .alert)
                
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    
                    
                    if let item = self.escapeItem {
                        item.isAlertSet = newState
                        
                        AnalyticsVader.sharedVader.undoTrack(escapeName: item.name, escapeId: item.id, escapeType: item.escapeType, position: self.trackPosition)
                        
                        TrackingDataProvider.shared.removeTrackingFor(escapeId: item.id)
                        self.updateTrackButton(newState: newState)
                    }
                })
                
                alert.addAction(removeAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                
                ScreenVader.sharedVader.showAlert(alert: alert)
            }
        } else {
            if let item = escapeItem {
                item.isAlertSet = newState
                AnalyticsVader.sharedVader.trackButtonClicked(escapeName: item.name, escapeId: item.id, escapeType: item.escapeType, position: trackPosition)
                TrackingDataProvider.shared.addTrackingFor(escapeId: item.id)
                updateTrackButton(newState: newState)
            }
        }
    }
    
    func updateTrackButton(newState: Bool) {
        
    }
    
    func updateAddEditButton() {
        ctaButton.isSelected = self.userHasActed
        
        if self.userHasActed {
            
        } else {
            
        }
    }
    
    @IBAction func didTapOnAddEditButton() {
        
        if let escapeItem = self.escapeItem {
            
            var paramsToPass: [String:Any] = ["escape_id" : escapeItem.id, "escape_type":escapeItem.escapeType, "escape_name": escapeItem.name, "delegate" : self]
            
            if let createdBy = escapeItem.createdBy {
                paramsToPass["createdBy"] = createdBy
            }
            
            if let imageUri = escapeItem.posterImage {
                paramsToPass["escape_image"] = imageUri
            }
            
            if self.userHasActed {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.EditButtonTap, properties: ["escapeName": escapeItem.name, "escapeType": escapeItem.escapeType, "Position":trackPosition])
            } else {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.AddButtonTap, properties: ["escapeName": escapeItem.name, "escapeType": escapeItem.escapeType, "Position":trackPosition])
            }
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openAddToWatchlistView, queryParams: ["mediaItem": escapeItem, "delegate": self])
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension EscapeCell: AddToWatchlistPopupProtocol {
    func addToWatchlistDone(isAlertSet: Bool) {
        
        if let escapeItem = self.escapeItem {
            escapeItem.isAlertSet = isAlertSet
            escapeItem.hasActed = true
        }
        self.userHasActed = true
        updateAddEditButton()
    }
}

extension EscapeCell: EditEscapeProtocol {
    func didDeleteEscape() {
        
        self.userHasActed = false
        updateAddEditButton()
    }
}

extension EscapeCell: AddToEscapeDoneProtocol {
    func doneButtonTapped() {
        self.userHasActed = true
        updateAddEditButton()
    }
    
}
