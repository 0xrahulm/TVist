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
    var isActed : Bool?
    var followers : NSNumber?
    
    init(id : String?,name : String?,image : String?,director : String?,isActed : Bool?,followers : NSNumber?) {
        
        self.id = id
        self.name = name
        self.image = image
        self.director = director
        self.isActed = isActed
        self.followers = followers
        
    }
    
    init(dict : [String:AnyObject]) {
        super.init()
        
        parseData(dict)
    }
    
    func parseData(dict : [String:AnyObject]){
        if let id = dict["id"] as? String{
            if let name = dict["name"] as? String{
                self.id  = id
                self.name = name
                
                self.image = dict["poster_image"] as? String
                
                if let director = dict["director"] as? String{
                    self.director = director
                }else if let author = dict["author"] as? String{
                    self.director = author
                }else if let creator = dict["creator"] as? String{
                    self.director = creator
                }
                
                self.isActed = dict["is_acted"] as? Bool
                self.followers = dict["followers"] as? NSNumber
                
                
            }
        }
        
    }

}
