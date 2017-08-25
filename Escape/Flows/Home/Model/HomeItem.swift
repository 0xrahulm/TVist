//
//  HomeItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class HomeItem: NSObject {
    var title:String?
    var itemType:Int = -1 // Default is Loading
    var escapeDataList:[EscapeItem] = []
    var listingsDataList: [ListingMediaItem] = []
    
    var totalItemsCount:Int = 0
    
    var id: String?
    
    init(itemType: HomeItemType) {
        self.itemType = itemType.rawValue
    }
    
    
    func itemTypeEnumValue() -> HomeItemType {
        return HomeItemType(rawValue: itemType)! // Bang because itemType will always be present, without which a profile item is useless
    }
    
    
    func parseDataList(_ dataList: [[String:AnyObject]]) {
        
        switch itemTypeEnumValue() {
        case .discover:
            parseEscapesData(dataList)
            break
        case .tracker:
            parseEscapesData(dataList)
            break
        case .articles:
            
            break
            
        case .videos:
            
            break
            
        case .genre:
            
            break
            
        case .listing:
            parseListingMediaItem(dataList)
            break
        
        }
    }
    
    class func createHomeItem(homeData: [String:AnyObject]) -> HomeItem? {
        
        guard let itemTypeRaw = itemData["item_type"] as? Int, let itemType = HomeItemType(rawValue: itemTypeRaw) else {
            return nil
        }
        
        let listItem = HomeItem(itemType: itemType)
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
    
    class func getLoadingItem() -> HomeItem {
        return HomeItem(itemType: HomeItemType.showLoading)
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
    
    func parseListingMediaItem(_ programListings: [[String:Any]]) {
        
        for programListing in programListings {
            if let programListItem = ListingMediaItem.parseListingMediaItem(programListing) {
                listingsDataList.append(programListItem)
            }
        }
    }
}
