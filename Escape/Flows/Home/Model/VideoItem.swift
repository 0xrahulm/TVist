//
//  VideoItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class VideoItem: NSObject {

    var id: String!
    var link: String!
    var thumbnail: String!
    var title: String?
    var source: String?
    
    func parseVideoItemData(_ data: [String:AnyObject]) -> VideoItem? {
        guard let thumbnail = data["thumbnail"] as? String, let id = data["id"] as? String, let link = data["link"] as? String else { return nil }
        
        let videoItem = VideoItem()
        
        videoItem.id = id
        
        videoItem.thumbnail = thumbnail
        videoItem.link = link
        
        videoItem.title = data["title"] as? String
        videoItem.source = data["source"] as? String
        
        return videoItem
    }
}
