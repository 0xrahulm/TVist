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
    var backDropImage : String?
    var desc: String?
    var releaseYear: String?
    var rating: NSNumber?
    
    var runtime: String? // In case of movies
    var pageCount: String? // In case of books
    
    var cast: String?
    var createdBy: String?
    var escapeType: String?
    var generes: [String] = []
    var isActed = false
    
    var isAlertSet: Bool = false
    var inWatchlist: Bool = false
    var isAlreadySeen: Bool = false
    
    var imdbId: String?
    
    var nextAirtime: Airtime?
    
    var streamingOptions: [StreamingOption] = []
    var viewingOptions: [ViewingOption] = []
    
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
                self.backDropImage = dict["backdrop_image"] as? String
                self.desc = dict["description"] as? String
                if let cleanDescription = dict["clean_description"] as? String {
                    self.desc = cleanDescription
                }
                self.releaseYear = dict["release_year"] as? String
                self.escapeType = dict["escape_type"] as? String
                
                if let rating = dict["average_rating"] as? NSNumber{
                    self.rating = rating
                }else if let rating = dict["imdb_rating"] as? NSNumber{
                    self.rating = rating
                }else if let rating = dict["escape_rating"] as? NSNumber{
                    self.rating = rating
                }
                
                if let rating = dict["imdb_rating"] as? NSNumber{
                    self.rating = rating
                }
                
                if let imdbID = dict["imdb_id"] as? String {
                    self.imdbId = imdbID
                }
                
                self.runtime = dict["run_time"] as? String
                if let pagesCount = dict["page_count"] as? Int {
                    self.runtime = String(pagesCount)+" pages"
                }
                self.cast = dict["cast"] as? String
                
                if let createdBy = dict["created_by"] as? String{
                    self.createdBy = createdBy
                }
                
                if let generes = dict["genres"] as? [String]{
                    self.generes = generes
                }
                
                if let streamingOptionsData = dict["streaming_options"] as? [[String:AnyObject]] {
                    for eachOption in streamingOptionsData {
                        if let streamingOption = StreamingOption.parseStreamingOptionData(data: eachOption) {
                            self.streamingOptions.append(streamingOption)
                        }
                    }
                }
                
                if let nextAirtime = dict["next_airtime"] as? [String:Any] {
                    self.nextAirtime = Airtime.createAirtime(nextAirtime)
                }
                
                if let viewingOptionsData = dict["viewing_options"] as? [[String:Any]] {
                    for eachOption in viewingOptionsData {
                        if let viewingOption = ViewingOption.parseViewingOptionData(data: eachOption) {
                            self.viewingOptions.append(viewingOption)
                        }
                    }
                }
            }
        }
        if let acted = data["is_watchlisted"] as? Bool{
            self.isActed = acted
            self.inWatchlist = acted
        }
        
        if let alert = data["is_alert"] as? Bool {
            self.isAlertSet = alert
        }
        
        if let seen = data["is_seen"] as? Bool {
            self.isAlreadySeen = seen
        }
        
    }
}
