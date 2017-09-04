//
//  ArticleItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ArticleItem: NSObject {

    var id: String!
    var title: String!
    var url: String!
    var image: String?
    var desc: String?
    var source: String?
    
    class func parseArticleItemData(_ data: [String:Any]) -> ArticleItem? {
        guard let title = data["title"] as? String, let id = data["id"] as? String, let url = data["url"] as? String else { return nil }
        
        let articleItem = ArticleItem()
        
        articleItem.id = id
        articleItem.title = title
        articleItem.image = data["image"] as? String
        articleItem.desc = data["description"] as? String
        articleItem.source = data["source"] as? String
        articleItem.url = url
        
        return articleItem
    }
}
