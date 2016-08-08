//
//  EscapeDataItems.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class EscapeDataItems: NSObject {
    
    var id : String?
    var name : String?
    var image : String?
    var year : String?
    var escapeRating : NSNumber?
    var escapeType : EscapeType?
    
    init(id : String?,name : String?,image : String?,escapeType : EscapeType?,escapeRating : NSNumber?,  year : String?) {
        
        self.id = id
        self.name = name
        self.image = image
        self.escapeType = escapeType
        self.escapeRating = escapeRating
        self.year = year
    }
    
    init(dict : [String:AnyObject]) {
        super.init()
        parseEscapeItems(dict)
    }
    
    func parseEscapeItems(dict : [String:AnyObject]){
        if let id = dict["id"] as? String,
           let name = dict["name"] as? String,
           let image = dict["poster_image"] as? String{
            
            self.id = id
            self.name = name
            self.image = image
            self.year = dict["year"] as? String
            
            if let type = dict["escape_type"] as? String{
                self.escapeType = EscapeType(rawValue: type)
            }
            self.escapeRating = dict["escape_rating"] as? NSNumber
            self.year = dict["year"] as? String
            
        }
    }
}
