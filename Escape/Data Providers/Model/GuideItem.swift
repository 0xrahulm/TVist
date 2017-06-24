//
//  GuideItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 13/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GuideItem: NSObject {
    
    var title:String?
    var itemType:Int = -1 // Default is Loading
    var escapeDataList:[EscapeItem] = []
    var totalItemsCount:Int = 0
    var associatedStoryCard: StoryCard?
    
    var id: String?
    
    init(itemType: GuideItemType) {
        self.itemType = itemType.rawValue
    }
    
    
    func itemTypeEnumValue() -> GuideItemType {
        return GuideItemType(rawValue: itemType)! // Bang because itemType will always be present, without which a profile item is useless
    }
    
    
    func parseDataList(_ dataList: [[String:AnyObject]]) {
        if itemTypeEnumValue() == .escapeList {
            parseEscapesData(dataList)
        }
    }
    
    class func createGuideItem(itemData: [String:AnyObject]) -> GuideItem? {
        var itemTypeVal:Int? = itemData["item_type"] as? Int
        if let _ = itemData["story_type"] as? Int {
            itemTypeVal = GuideItemType.userStory.rawValue
        }
        
        guard let itemTypeRaw = itemTypeVal, let itemType = GuideItemType(rawValue: itemTypeRaw) else {
            return nil
        }
        
        let guideItem = GuideItem(itemType: itemType)
        guideItem.id = itemData["id"] as? String
        
        if itemType == GuideItemType.userStory {
            if let storyTypeVal = itemData["story_type"] as? NSNumber, let storyType = StoryType(rawValue: storyTypeVal) {
                switch storyType {
                case .fbFriendFollow:
                    guideItem.associatedStoryCard = FBFriendCard(dict: itemData)
                    break
                    
                case .addToEscape:
                    guideItem.associatedStoryCard = AddToEscapeCard(dict: itemData)
                    break
                    
                case .recommeded:
                    guideItem.associatedStoryCard = AddToEscapeCard(dict: itemData)
                    break
                    
                default:
                    return nil
                }
            }
        } else if itemType == GuideItemType.showDiscoverNow {
            
            guideItem.title =  itemData["section_title"] as? String
            
            if let total_count = itemData["total_items_count"] as? NSNumber {
                guideItem.totalItemsCount = total_count.intValue
            }
            
        } else {
            
            guideItem.title =  itemData["section_title"] as? String
            
            if let total_count = itemData["total_items_count"] as? NSNumber {
                guideItem.totalItemsCount = total_count.intValue
            }
            
            
            if let listedData = itemData["data"] as? [[String:AnyObject]] {
                guideItem.parseDataList(listedData)
            }
        }
        
        return guideItem
    }
    
    class func getLoadingItem() -> GuideItem {
        return GuideItem(itemType: GuideItemType.showLoading)
    }
    
    func parseEscapesData(_ escapesData: [[String:AnyObject]]) {
        for eachEscapeData in escapesData {
            guard let id = eachEscapeData["id"] as? String, let name = eachEscapeData["name"] as? String, let escapeType = eachEscapeData["escape_type"] as? String else {
                continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(id, name: name, escapeType: escapeType, posterImage: eachEscapeData["poster_image"] as? String, year: eachEscapeData["year"] as? String, rating: eachEscapeData["rating"] as? NSNumber, subTitle: eachEscapeData["subtitle"] as? String, createdBy: eachEscapeData["creator"] as? String, _realm: nil)
            
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
