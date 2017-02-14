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
    
    func parseDataNoRealm(profileItemData:[[String:AnyObject]]) {
        for eachItem in profileItemData {
            guard let itemType = eachItem["type"] as? Int, let _ = ProfileItemType(rawValue: itemType) else {
                continue
            }
            let profileItem = ProfileItem()
            profileItem.title =  eachItem["title"] as? String
            profileItem.itemType = itemType
            
            if let total_count = eachItem["total_items_count"] as? NSNumber {
                profileItem.totalItemsCount = total_count.integerValue
            }
            
            
            if let listedData = eachItem["data"] as? [[String:AnyObject]] {
                profileItem.parseDataListNoRealm(listedData)
            }
            
            data.append(profileItem)
        }
        
    }
    
    func parseDataList(profileItemData: [[String:AnyObject]], _realm: Realm) {
        
        for eachItem in profileItemData {
            guard let itemType = eachItem["type"] as? Int, let _ = ProfileItemType(rawValue: itemType) else {
                continue
            }
            let profileItem = ProfileItem()
            profileItem.title =  eachItem["title"] as? String
            profileItem.itemType = itemType
            
            if let total_count = eachItem["total_items_count"] as? NSNumber {
                profileItem.totalItemsCount = total_count.integerValue
            }
            
            if let listedData = eachItem["data"] as? [[String:AnyObject]] {
                profileItem.parseDataList(listedData, _realm: _realm)
            }
            
            data.append(profileItem)
        }
    }
    
    
}
