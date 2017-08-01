//
//  ListingDate.swift
//  Mizzle
//
//  Created by Rahul Meena on 26/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingDate: NSObject {
    
    var id: String?
    var label: String?
    var dateString: String?
    var startTime: String!
    var endTime: String?
    var imageUrl: String?
    var isToday: Bool = false
    
    class func createListingDate(data: [String:AnyObject]) -> ListingDate? {
        
        guard let startTime = data["start_time"] as? String, let id = data["id"] as? String else {
            return nil
        }
        
        let listingDate = ListingDate()
        listingDate.id = id
        listingDate.startTime = startTime
        listingDate.label = data["label"] as? String
        listingDate.endTime = data["end_time"] as? String
        listingDate.imageUrl = data["image_url"] as? String
        listingDate.dateString = data["date_string"] as? String
        if let isToday = data["is_today"] as? Bool {
            listingDate.isToday = isToday
        }
        
        return listingDate
        
    }
    
}
