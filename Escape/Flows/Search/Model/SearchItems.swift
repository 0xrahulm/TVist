//
//  SearchItems.swift
//  Escape
//
//  Created by Ankit on 17/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class SearchItems: NSObject {
    
    var id : String?
    var name : String?
    var image : String?
    var year : String?
    var subTitle: String?
    var director : String?
    var searchType : SearchType?
    
    var searchData : [SearchItems] = []
    var isAddedOrFollow = false
    
    
    init(id : String?,name : String?,image : String?,director : String?, searchType : SearchType? , isAddedOrFollow : Bool) {
        
        self.id = id
        self.name = name
        self.image = image
        self.director = director
        self.searchType = searchType
        self.isAddedOrFollow = isAddedOrFollow
        
    }
    
    init(dict : [AnyObject]) {
        super.init()
        
        parseData(dict)
    }
    init(searchType : SearchType) {
        self.searchType = searchType
    }
    
    func parseData(_ data : [AnyObject]){
        var searchDataArray : [SearchItems] = []
        
        if let dataArray = data as? [[String:AnyObject]]{
            for dict in dataArray{
                if let id = dict["id"] as? String,
                    let name = dict["name"] as? String,
                    let image = dict["picture"] as? String,
                    let searchType = dict["search_type"] as? String,
                    let isAddedOrFollow = dict["is_acted"] as? Bool{
                    
                    searchDataArray.append(SearchItems(id: id, name: name, image: image, director: dict["creator"] as? String, searchType: SearchType(rawValue:searchType), isAddedOrFollow: isAddedOrFollow))
   
                }
                
            }
        }
        
        self.searchData = searchDataArray
    }

}
