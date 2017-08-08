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
    @IBOutlet weak var creatorTypeLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    
    @IBOutlet weak var airtimeLabel: UILabel!
    
    @IBOutlet weak var trackButton: UIButton!
    
    
    var userHasActed:Bool = false
    var trackPosition: String!
    
    var escapeItem: EscapeItem? {
        didSet {
            attachData()
        }
    }
    
    func attachData() {
        
        if let escapeItem = escapeItem {
            var escapeTitleStr = escapeItem.name
            let year = escapeItem.year
            if year.characters.count > 0 && escapeItem.escapeTypeVal() != .Books {
                escapeTitleStr += " (\(year))"
            }
            titleLabel.text = escapeTitleStr
            
            posterImageView.downloadImageWithUrl(escapeItem.posterImage, placeHolder: UIImage(named: "movie_placeholder"))
            
            if let createdBy = escapeItem.createdBy {
                creatorNameLabel.text = createdBy
                creatorNameLabel.isHidden = false
            }else{
                creatorNameLabel.isHidden = true
            }
            
            if escapeItem.escapeTypeVal() == .Movie {
                creatorTypeLabel.text = EscapeCreatorType.Movie.rawValue
            }else if escapeItem.escapeTypeVal() == .Books{
                creatorTypeLabel.text = EscapeCreatorType.Books.rawValue
            }else if escapeItem.escapeTypeVal() == .TvShows{
                creatorTypeLabel.text = EscapeCreatorType.TvShows.rawValue
            }
            
            if let nextAirtime = escapeItem.nextAirtime {
                var airText:String = ""
                if let airDate = nextAirtime.airDate {
                    airText += "\(airDate) "
                }
                airText += "\(nextAirtime.airTime!)"
                
                if let channelName = nextAirtime.channelName {
                    airText += " on \(channelName)"
                }
                self.airtimeLabel.text = airText
            } else {
                self.airtimeLabel.text = "Not airing in next 7 days."
            }
            
            self.ratingLabel.text = escapeItem.rating
            
            self.userHasActed = escapeItem.hasActed
            
            if trackButton != nil {
                
                trackButton.setImage(IonIcons.image(withIcon: ion_android_time, size: 20, color: UIColor.white), for: .normal)
                trackButton.setImage(IonIcons.image(withIcon: ion_android_done_all, size: 20, color: UIColor.white), for: .selected)
            }
            

            
            if trackButton != nil {
                updateTrackButton(newState: escapeItem.isTracking)
            }
            
            updateAddEditButton()
            
        }
    }
    
    
    
    @IBAction func trackButtonTapped(sender: UIButton) {
        
        toggleButtonState()
    }
    
    func toggleButtonState() {
        trackButton.popButtonAnimate()
        let newState = !trackButton.isSelected
        if !newState {
            if let itemName = escapeItem?.name {
                
                let alert = UIAlertController(title: "Are you sure?", message: "Tracking for \(itemName) is already setup, would you like to remove it?", preferredStyle: .alert)
                
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    
                    
                    if let item = self.escapeItem {
                        item.isTracking = newState
                        
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
                item.isTracking = newState
                AnalyticsVader.sharedVader.trackButtonClicked(escapeName: item.name, escapeId: item.id, escapeType: item.escapeType, position: trackPosition)
                TrackingDataProvider.shared.addTrackingFor(escapeId: item.id)
                updateTrackButton(newState: newState)
            }
        }
    }
    
    func updateTrackButton(newState: Bool) {
        
        trackButton.isSelected = newState
        if newState {
            trackButton.backgroundColor = UIColor.defaultCTAColor()
        } else {
            trackButton.backgroundColor = UIColor.defaultTintColor()
        }
    }
    
    func updateAddEditButton() {
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
                ScreenVader.sharedVader.performScreenManagerAction(.OpenEditEscapePopUp, queryParams: paramsToPass)
            } else {
                ScreenVader.sharedVader.performScreenManagerAction(.OpenAddToEscapePopUp, queryParams: paramsToPass)
            }
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
