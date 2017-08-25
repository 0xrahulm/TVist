//
//  HomeData.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class HomeData: NSObject {

    var data: [HomeItem] = []
    var userId: String?
    
    
    func parseData(_ listingItemsData:[[String:AnyObject]]) {
        for eachItem in listingItemsData {
            
            if let listingItem = HomeItem.createHomeItem(itemData: eachItem) {
                data.append(listingItem)
            }
        }
        
    }
}
