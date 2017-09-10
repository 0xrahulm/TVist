//
//  ListingIndex.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingIndex: NSObject {
    
    var data: [ListingItem] = []
    var userId: String?
    
    
    func parseData(_ listingItemsData:[[String:AnyObject]]) {
        for eachItem in listingItemsData {
            
            if let listingItem = ListingItem.createListingItem(itemData: eachItem) {
                data.append(listingItem)
            }
        }
        
    }

}
