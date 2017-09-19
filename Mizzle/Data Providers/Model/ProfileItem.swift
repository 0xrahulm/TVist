//
//  ProfileItem.swift
//  Escape
//
//  Created by Rahul Meena on 23/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import RealmSwift

final class ProfileItem: Object {
    @objc dynamic var title:String?
    @objc dynamic var itemType:Int = -1 // Default is Loading
    let escapeDataList = List<EscapeItem>()
    @objc dynamic var totalItemsCount:Int = 0
    
    var associatedStoryCard: StoryCard?
    
    override static func ignoredProperties() -> [String] {
        return ["associatedStoryCard"]
    }
    
    func itemTypeEnumValue() -> ProfileItemType {
        return ProfileItemType(rawValue: itemType)! // Bang because itemType will always be present, without which a profile item is useless
    }
    
    func parseDataList(_ dataList: [[String:AnyObject]], _realm: Realm) {
        if itemTypeEnumValue() == .escapeList {
            parseEscapesData(dataList, _realm: _realm)
        }
    }
    
    func parseDataListNoRealm(_ dataList: [[String:AnyObject]]) {
        if itemTypeEnumValue() == .escapeList {
            parseEscapesDataNoRealm(dataList)
        }
    }
    
    func parseEscapesDataNoRealm(_ escapesData: [[String:AnyObject]]) {
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
    
    func parseEscapesData(_ escapesData: [[String:AnyObject]], _realm: Realm) {
        for eachEscapeData in escapesData {
            guard let id = eachEscapeData["id"] as? String, let name = eachEscapeData["name"] as? String, let escapeType = eachEscapeData["escape_type"] as? String else {
                continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(id, name: name, escapeType: escapeType, posterImage: eachEscapeData["poster_image"] as? String, year: eachEscapeData["year"] as? String, rating: eachEscapeData["rating"] as? NSNumber, subTitle: eachEscapeData["subtitle"] as? String, createdBy: eachEscapeData["creator"] as? String, _realm: _realm, nextAirtime: eachEscapeData["next_airtime"] as? [String:Any])
            escapeDataList.append(escapeItem)
            
            
        }
    }
}
