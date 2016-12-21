//
//  ArticleCard.swift
//  Escape
//
//  Created by Ankit on 11/12/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class ArticleCard: StoryCard {
    
    var articleId : String?
    var articleTitle : String?
    var articleImage : String?
    var articleUrl : String?
    
    
    override init(dict: [String : AnyObject]) {
        super.init(dict: dict)
        
        parseEscapeCard()
    }
    
    func parseEscapeCard(){
        
        if let objData = self.storyData{
            for dict in objData{
                self.articleId = dict["id"] as? String
                self.articleTitle = dict["title"] as? String
                self.articleImage = dict["image"] as? String
                self.articleUrl = dict["url"] as? String
            }
        }
    }

}
