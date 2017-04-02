//
//  DescDataItems.swift
//  Escape
//
//  Created by Ankit on 22/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DescDataItems: NSObject {
    
    var id: String?
    var name: String?
    var subtitle: String?
    var image: String?
    var desc: String?
    var releaseYear: String?
    var rating: NSNumber?
    
    var runtime: String? // In case of movies
    var pageCount: String? // In case of books
    
    var cast: String?
    var createdBy: String?
    var generes: [String] = []
    var isActed = false
    
    init(dict: [String:AnyObject]) {
        super.init()
        
        parseData(dict)
    }
    
    func parseData(_ data : [String:AnyObject]){
        
        if let dict = data["details"] as? [String:AnyObject]{
            
            if let name  = dict["name"] as? String{
                
                self.name = name
                self.id = dict["id"] as? String
                self.subtitle = dict["subtitle"] as? String
                self.image = dict["poster_image"] as? String
                self.desc = dict["description"] as? String
                self.releaseYear = dict["release_year"] as? String
                
                if let rating = dict["average_rating"] as? NSNumber{
                    self.rating = rating
                }else if let rating = dict["imdb_rating"] as? NSNumber{
                    self.rating = rating
                }else if let rating = dict["escape_rating"] as? NSNumber{
                    self.rating = rating
                }
                
                self.runtime = dict["run_time"] as? String
                self.cast = dict["cast"] as? String
                
                if let createdBy = dict["created_by"] as? String{
                    self.createdBy = createdBy
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
