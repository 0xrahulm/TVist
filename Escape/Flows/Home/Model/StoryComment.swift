//
//  StoryComment.swift
//  Escape
//
//  Created by Ankit on 19/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class StoryComment: NSObject {
    
    var comment : String?
    var createdAt : String?
    var creator : Creator?
    
    
    var comments : [StoryComment] = []
    
    init(dict : [String:AnyObject]) {
        super.init()
        parseData(dict)
    }
    
    init(commentArray : [AnyObject]) {
        super.init()
        parseArray(commentArray)
    }
    
    func parseData(dict : [String:AnyObject]){
        self.comment = dict["comment"] as? String
        self.createdAt = dict["created_at"] as? String
        if let creatorDict = dict["creator"] as? [String:AnyObject]{
            self.creator = Creator(dict: creatorDict)
        }
        
        
    }
    func parseArray(commentArray : [AnyObject]){
        
        for comment in commentArray{
            if let dict = comment as? [String:AnyObject]{
                if let _ = dict["comment"] as? String,
                    let _ = dict["creator"] as? [String:AnyObject]{
                    
                    self.comments.append(StoryComment(dict: dict))
                }
                
            }
        }
    }

}
