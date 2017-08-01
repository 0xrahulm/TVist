//
//  ListingMediaItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingMediaItem: NSObject {
    
    var id: String?
    var airtime: String!
    var airdate: String?
    var mediaItem: MediaItem!
    var episodeItem: EpisodeItem?
    
    class func parseListingMediaItem(_ data: [String:Any]) -> ListingMediaItem? {
        guard let airtime = data["airtime"] as? String, let mediaItemData = data["media_item"] as? [String:AnyObject], let mediaItem = MediaItem.parseMediaItemData(data: mediaItemData) else { return nil }
        
        let listingMediaItem = ListingMediaItem()
        
        listingMediaItem.airdate = data["airdate"] as? String
        listingMediaItem.airtime = airtime
        listingMediaItem.mediaItem = mediaItem
        
        if let linkedEpisodeData = data["linked_episode"] as? [String: AnyObject] {
            listingMediaItem.episodeItem = EpisodeItem.parseEpisodeItem(data: linkedEpisodeData)
        }
        
        return listingMediaItem
        
    }
    
    
    func constructedTitle() -> String {
        var constructedTitle = ""
        
        if let mediaName = mediaItem.name {
            constructedTitle = mediaName
            
            if let episodeItem = episodeItem {
                constructedTitle = constructedTitle + " " + episodeItem.numericalString()
            } else {
                if let year = mediaItem.year {
                    constructedTitle = constructedTitle + " (\(year))"
                }
            }
        }
        
        return constructedTitle
    }
    
}
