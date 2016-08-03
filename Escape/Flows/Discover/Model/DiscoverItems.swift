//
//  DiscoverItems.swift
//  Escape
//
//  Created by Ankit on 01/06/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DiscoverItems: NSObject {
    
    var id : String?
    var name : String?
    var image : String?
    var director : String?
    var followers : NSNumber?
    var year:       String?
    var subtitle : String?
    var discoverType : DiscoverType?
    var rating : NSNumber?
    var discoverData : [DiscoverItems] = []
    var isFollow = false
    
    
    init(id : String?,name : String?,image : String?,director : String?, followers : NSNumber?, year : String? , subtitle : String? , discoverType : DiscoverType? , rating : NSNumber?, isFollow : Bool) {
        
        self.id = id
        self.name = name
        self.image = image
        self.director = director
        self.followers = followers
        self.year = year
        self.subtitle = subtitle
        self.discoverType = discoverType
        self.rating = rating
        self.isFollow = isFollow
       
    }
    
    init(dict : [AnyObject]) {
        super.init()
        
        parseData(dict)
    }
    
    func parseData(data : [AnyObject]){
        var discoverDataArray : [DiscoverItems] = []
        
        if let dataArray = data as? [[String:AnyObject]]{
            for dict in dataArray{
                if let id = dict["id"] as? String{
                    if let name = dict["name"] as? String{
                        if let image = dict["poster_image"] as? String{
                            if let discoverType = dict["escape_type"] as? String{
                                
                                discoverDataArray.append(DiscoverItems(id: id, name: name, image: image, director: dict["creator"] as? String, followers: dict["followers"] as? NSNumber, year: dict["release_year"] as? String, subtitle: dict["subtitle"] as? String, discoverType: DiscoverType(rawValue: discoverType), rating: dict["escape_rating"] as? NSNumber, isFollow : false))
                                
                            }
                            
                        }
                    }else if let fullName = dict["full_name"] as? String{
                        if let image = dict["profile_picture"] as? String{
                            if let isfollow  = dict["is_following"] as? Bool{
                                discoverDataArray.append(DiscoverItems(id: id, name: fullName, image: image, director: nil, followers: nil, year: nil, subtitle: nil, discoverType: .People, rating: nil, isFollow : isfollow))
                            }
                        }
                        
                    }
                }
                
            }
        }
        
        self.discoverData = discoverDataArray
    }
}
