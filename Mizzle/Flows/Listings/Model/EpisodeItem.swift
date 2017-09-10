//
//  EpisodeItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 28/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class EpisodeItem: NSObject {
    
    var id: String?
    var name: String?
    var summary: String?
    var imageLink: String?
    var seasonNumber: Int?
    var episodeNumber: Int = 0
    
    class func parseEpisodeItem(data: [String:AnyObject]) -> EpisodeItem? {
        
        guard let itemId = data["id"] as? String, let episodeNumber = data["episode_number_val"] as? Int else { return nil }
        
        let episodeItem = EpisodeItem()
        
        episodeItem.id = itemId
        episodeItem.episodeNumber = episodeNumber
        episodeItem.seasonNumber = data["season_number_val"] as? Int
        episodeItem.name = data["name"] as? String
        episodeItem.summary = data["summary"] as? String
        
        return episodeItem
    }
    
    func numericalString() -> String {
        var numericalString:String = ""
        
        if let seasonNumber = seasonNumber {
            numericalString += "S\(String(format: "%02d", seasonNumber))"
        }
        
        numericalString += "E\(String(format: "%02d", episodeNumber))"
        
        return numericalString
    }
}
