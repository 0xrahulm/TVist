//
//  DescDataItems.swift
//  Escape
//
//  Created by Ankit on 22/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DescDataItems: NSObject {
    
    var id : String?
    var name : String?
    var subtitle : String?
    var image : String?
    var desc : String?
    var releaseDate : Double?
    var yearRange : String?
    var rating : NSNumber?
    var runtime : String?
    var cast : String?
    var director : String?
    var generes : [String] = []
    var isActed  = false
    
    init(dict : [String:AnyObject]) {
        
        super.init()
        
        parseData(dict)
        
    }
    
    func parseData(data : [String:AnyObject]){
        
        if let dict = data["escape_details"] as? [String:AnyObject]{
            
            if let name  = dict["name"] as? String{
                
                self.name = name
                self.id = dict["id"] as? String
                self.subtitle = dict["subtitle"] as? String
                self.image = dict["poster_image"] as? String
                self.desc = dict["description"] as? String
                self.releaseDate = dict["release_date"] as? Double
                
                if let rating = dict["average_rating"] as? NSNumber{
                    self.rating = rating
                }else if let rating = dict["imdb_rating"] as? NSNumber{
                    self.rating = rating
                }
                
                self.runtime = dict["runtime"] as? String
                self.yearRange = dict["year_range"] as? String
                self.cast = dict["cast"] as? String
                
                if let director = dict["director"] as? String{
                    self.director = director
                }else if let author = dict["author"] as? String{
                    self.director = author
                }else if let creator = dict["creator"] as? String{
                    self.director = creator
                }
                
                
                if let generes = dict["genres"] as? [String]{
                    self.generes = generes
                }
            }
        }
        if let acted = data["is_acted"] as? Bool{
            self.isActed = acted
        }

        
    }
}
