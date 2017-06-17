//
//  GuideList.swift
//  Mizzle
//
//  Created by Rahul Meena on 13/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GuideList: NSObject {
    var type: GuideListType?
    var data: [GuideItem] = []
    var userId: String?
    
    func parseData(_ guideItemsData:[[String:AnyObject]]) {
        for eachItem in guideItemsData {
            
            var itemTypeVal:Int? = eachItem["type"] as? Int
            if let _ = eachItem["story_type"] as? Int {
                itemTypeVal = GuideItemType.userStory.rawValue
            }
            
            guard let itemTypeRaw = itemTypeVal, let itemType = GuideItemType(rawValue: itemTypeRaw) else {
                continue
            }
            
            let guideItem = GuideItem(itemType: itemType)
            
            if itemType == GuideItemType.userStory {
                if let storyTypeVal = eachItem["story_type"] as? NSNumber, let storyType = StoryType(rawValue: storyTypeVal) {
                    switch storyType {
                    case .fbFriendFollow:
                        guideItem.associatedStoryCard = FBFriendCard(dict: eachItem)
                        break
                        
                    case .addToEscape:
                        guideItem.associatedStoryCard = AddToEscapeCard(dict: eachItem)
                        break
                        
                    case .recommeded:
                        guideItem.associatedStoryCard = AddToEscapeCard(dict: eachItem)
                        break
                        
                    default:
                        continue
                    }
                }
            } else if itemType == GuideItemType.showDiscoverNow {
                
                guideItem.title =  eachItem["title"] as? String
                
                if let total_count = eachItem["total_items_count"] as? NSNumber {
                    guideItem.totalItemsCount = total_count.intValue
                }
                
            } else {
                
                guideItem.title =  eachItem["title"] as? String
                
                if let total_count = eachItem["total_items_count"] as? NSNumber {
                    guideItem.totalItemsCount = total_count.intValue
                }
                
                
                if let listedData = eachItem["data"] as? [[String:AnyObject]] {
                    guideItem.parseDataList(listedData)
                }
            }
            
            data.append(guideItem)
        }
        
    }
}
