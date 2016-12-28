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
    var shareCount = 3
    
    var isLiked = false
    var isCommented = false
    var isShared = false
    
    var sharedText : String?
    
    var recommededUsers:[Creator] = []
    
    var actionVerb = ""
    var preposition = ""
    
    
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
                
                if let cName = creatorData["full_name"] as? String{
                    self.creatorName =   cName
                }else if let cName = creatorData["name"] as? String{ //article card case
                    self.creatorName = cName
                }
                
                if let cImage = creatorData["profile_picture"] as? String{
                    self.creatorImage =  cImage
                    
                }else if let cImage = creatorData["image"] as? String{//article card case
                    self.creatorImage =  cImage
                }
            }
            
            self.creatorStatus = dict["status"] as? String
            self.title =         dict["title"] as? String
            self.timestamp =     dict["posted_at"] as? NSNumber
            
            if let likes = dict["likes_count"] as? NSNumber{
                self.likesCount = Int(likes)
            }
            
            if let comment = dict["comments_count"] as? NSNumber{
                self.commentsCount = Int(comment)
            }
            
            if let recommededUsers = dict["recommended_users"] as? [[String:AnyObject]]{
                for dict in recommededUsers{
                    self.recommededUsers.append(Creator(dict: dict))
                }
            }
            if let recommededUsers = dict["tagged_users"] as? [[String:AnyObject]]{
                for dict in recommededUsers{
                    self.recommededUsers.append(Creator(dict: dict))
                }
            }
            
            if let states = dict["states"] as? [String:AnyObject]{
                if let like = states["liked"] as? Bool{
                    self.isLiked = like
                }
                if let comment = states["commented"] as? Bool{
                    self.isCommented = comment
                }
                if let share = states["shared"] as? Bool{
                    self.isShared = share
                }
            }
            
            if let titleAttrbs = dict["title_attrs"] as? [String:AnyObject]{
                if let verb = titleAttrbs["action_verb"] as? String{
                    self.actionVerb = verb
                }
                if let prep = titleAttrbs["preposition"] as? String{
                    self.preposition = prep
                }
            }
            
            if let sharedText = dict["share_text"] as? String{
                self.sharedText = sharedText
            }
        }
    }
}
