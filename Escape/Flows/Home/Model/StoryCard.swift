//
//  StoryCard.swift
//  Escape
//
//  Created by Ankit on 04/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class StoryCard: BaseStory {
    
    
    var id:             String?
    var storyType:      StoryType?
    var title:          String?
    var createrId:      String?
    var creatorType:    CreatorType?
    var storyData:      [AnyObject]?
    var creatorName:    String?
    var creatorImage:   String?
    var creatorStatus:  String?
    var timestamp:      NSNumber?
    var likesCount = 0
    var commentsCount = 0
    var recommededUsers:[String] = []
    
    
    init(dict : [String:AnyObject]) {
        
        super.init()
        
        parseStoryCard(dict)
    }
    
    init(storyType : StoryType) {
        self.storyType = storyType
    }
    
    func parseStoryCard(dict : [String:AnyObject]){
        
        if let storyId =        dict["id"] as? String,
           let storyType =      dict["story_type"] as? NSNumber,
           let storyObjs =      dict["objects"] as? [AnyObject] {
            
            if let creatorData = dict["creator"] as? [String:AnyObject],
               let createrId =   creatorData["id"] as? String,
               let creatorType = creatorData["type"] as? NSNumber{
                
                self.id =            storyId
                self.storyType =     StoryType(rawValue: storyType)
                self.storyData =     storyObjs
                self.createrId =     createrId
                self.creatorType =   CreatorType(rawValue: creatorType)
                self.creatorName =   creatorData["full_name"] as? String
                self.creatorImage =  creatorData["profile_picture"] as? String
                self.creatorStatus = dict["status"] as? String
                self.title =         dict["title"] as? String
                self.timestamp =     dict["posted_at"] as? NSNumber
                
                if let likes = dict["likes_count"] as? NSNumber{
                    self.likesCount = Int(likes)
                }
                if let comment = dict["comments_count"] as? NSNumber{
                    self.commentsCount = Int(comment)
                }
                
                if let recommededUsers = dict["recommended_users"] as? [String]{
                    self.recommededUsers   = recommededUsers
                }
                
            }
        }
    }
}
