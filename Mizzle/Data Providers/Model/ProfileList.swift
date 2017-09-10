//
//  ProfileList.swift
//  Escape
//
//  Created by Rahul Meena on 23/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import RealmSwift

final class ProfileList: Object {
    dynamic var type:String = ""
    dynamic var userId:String = ""
    dynamic var id:String = ""
    
    var data = List<ProfileItem>()
    
    override class func primaryKey() -> String? { return "id" }
    
    override static func indexedProperties() -> [String] {
        return ["type", "userId"]
    }
    
    class func getLoadingTypePorfileList() -> ProfileList {
        let profileList = ProfileList()
        
        let profileItem = ProfileItem()
        profileList.data.append(profileItem)
        
        return profileList
    }
    
    func parseDataNoRealm(_ profileItemData:[[String:AnyObject]]) {
        for eachItem in profileItemData {
            
            var itemTypeVal:Int? = eachItem["type"] as? Int
            if let _ = eachItem["story_type"] as? Int {
                itemTypeVal = ProfileItemType.userStory.rawValue
            }
            
            guard let itemType = itemTypeVal, let _ = ProfileItemType(rawValue: itemType) else {
                continue
            }
            
            let profileItem = ProfileItem()
            profileItem.itemType = itemType
            
            if itemType == ProfileItemType.userStory.rawValue {
                if let storyTypeVal = eachItem["story_type"] as? NSNumber, let storyType = StoryType(rawValue: storyTypeVal) {
                    switch storyType {
                    case .fbFriendFollow:
                        profileItem.associatedStoryCard = FBFriendCard(dict: eachItem)
                        break
                        
                    case .addToEscape:
                        profileItem.associatedStoryCard = AddToEscapeCard(dict: eachItem)
                        break
                        
                    case .recommeded:
                        profileItem.associatedStoryCard = AddToEscapeCard(dict: eachItem)
                        break
                        
                    default:
                        continue
                    }
                }
            } else if itemType == ProfileItemType.showDiscoverNow.rawValue {
                
                profileItem.title =  eachItem["title"] as? String
                
                if let total_count = eachItem["total_items_count"] as? NSNumber {
                    profileItem.totalItemsCount = total_count.intValue
                }
                    
            } else {
                
                profileItem.title =  eachItem["title"] as? String
                
                if let total_count = eachItem["total_items_count"] as? NSNumber {
                    profileItem.totalItemsCount = total_count.intValue
                }
                
                
                if let listedData = eachItem["data"] as? [[String:AnyObject]] {
                    profileItem.parseDataListNoRealm(listedData)
                }
            }
            
            data.append(profileItem)
        }
        
    }
    
    func parseDataList(_ profileItemData: [[String:AnyObject]], _realm: Realm) {
        
        for eachItem in profileItemData {
            guard let itemType = eachItem["type"] as? Int, let _ = ProfileItemType(rawValue: itemType) else {
                continue
            }
            let profileItem = ProfileItem()
            profileItem.title =  eachItem["title"] as? String
            profileItem.itemType = itemType
            
            if let total_count = eachItem["total_items_count"] as? NSNumber {
                profileItem.totalItemsCount = total_count.intValue
            }
            
            if let listedData = eachItem["data"] as? [[String:AnyObject]] {
                profileItem.parseDataList(listedData, _realm: _realm)
            }
            
            data.append(profileItem)
        }
    }
    
    
}
