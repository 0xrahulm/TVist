//
//  MediaItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class MediaItem: NSObject {
    
    var id: String?
    var name: String?
    var posterImage: String?
    var type: String?
    var cast: String?
    var year: String?
    var desc: String?
    var rating: String?
    var ratingNum: NSNumber?
    
    var episodeItem: EpisodeItem?
    
    class func parseMediaItemData(data: [String:AnyObject]) -> MediaItem? {
        
        guard let itemId = data["id"] as? String, let name = data["name"] as? String else { return nil }
        
        
        let mediaItem = MediaItem()
        
        mediaItem.id = itemId
        mediaItem.name = name
        
        mediaItem.posterImage = data["poster_image"] as? String
        mediaItem.type = data["type"] as? String
        mediaItem.year = data["release_year"] as? String
        mediaItem.cast = data["cast"] as? String
        
        
        if let rating = data["rating"] as? NSNumber {
            mediaItem.ratingNum = rating
            mediaItem.rating = String(format: "%.1f", rating.floatValue)
        }
        return mediaItem
    }
}
