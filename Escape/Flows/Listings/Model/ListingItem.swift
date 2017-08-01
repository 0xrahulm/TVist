//
//  ListingItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingItem: NSObject {
    var title:String?
    var itemType:Int = -1 // Default is Loading
    var escapeDataList:[EscapeItem] = []
    
    
    var totalItemsCount:Int = 0
    
    var id: String?
    
    init(itemType: ListingItemType) {
        self.itemType = itemType.rawValue
    }
    
    
    func itemTypeEnumValue() -> ListingItemType {
        return ListingItemType(rawValue: itemType)! // Bang because itemType will always be present, without which a profile item is useless
    }
    
    
    func parseDataList(_ dataList: [[String:AnyObject]]) {
        
        
        if itemTypeEnumValue() == ListingItemType.listingDays {
            parseListingDates(dataList)
        } else if (itemTypeEnumValue() == ListingItemType.pickChannel) {
            ListingsDataProvider.shared.parseListingCategories(dataList)
        } else if itemTypeEnumValue() == .mediaList {
            parseEscapesData(dataList)
        }
    }
    
    class func createListingItem(itemData: [String:AnyObject]) -> ListingItem? {
        
        guard let itemTypeRaw = itemData["item_type"] as? Int, let itemType = ListingItemType(rawValue: itemTypeRaw) else {
            return nil
        }
        
        let listItem = ListingItem(itemType: itemType)
        listItem.id = itemData["id"] as? String
        
        listItem.title =  itemData["section_title"] as? String
        
        if let total_count = itemData["total_items_count"] as? NSNumber {
            listItem.totalItemsCount = total_count.intValue
        }
        
        if let listedData = itemData["data"] as? [[String:AnyObject]] {
            listItem.parseDataList(listedData)
        }
        
        return listItem
    }
    
    class func getLoadingItem() -> ListingItem {
        return ListingItem(itemType: ListingItemType.showLoading)
    }
    
    func parseListingDates(_ listingDates: [[String:AnyObject]]) {
        for listingDate in listingDates {
            if let listingDate = ListingDate.createListingDate(data: listingDate) {
                ListingsDataProvider.shared.listingDates.append(listingDate)
            }
        }
    }
    
    func parseEscapesData(_ escapesData: [[String:AnyObject]]) {
        for eachEscapeData in escapesData {
            guard let id = eachEscapeData["id"] as? String, let name = eachEscapeData["name"] as? String, let escapeType = eachEscapeData["escape_type"] as? String else {
                continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(id, name: name, escapeType: escapeType, posterImage: eachEscapeData["poster_image"] as? String, year: eachEscapeData["year"] as? String, rating: eachEscapeData["rating"] as? NSNumber, subTitle: eachEscapeData["subtitle"] as? String, createdBy: eachEscapeData["creator"] as? String, _realm: nil, nextAirtime: eachEscapeData["next_airtime"] as? [String:Any])
            
            if let isTracking = eachEscapeData["is_tracking"] as? Bool {
                escapeItem.isTracking = isTracking
            }
            if let hasActed = eachEscapeData["is_acted"] as? Bool {
                escapeItem.hasActed = hasActed
            }
            escapeDataList.append(escapeItem)
            
        }
    }
    
}
