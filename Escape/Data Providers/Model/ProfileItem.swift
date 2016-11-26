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
    dynamic var title:String?
    dynamic var itemType:Int = 0 // Default is Escape list
    let escapeDataList = List<EscapeItem>()
    
    func itemTypeEnumValue() -> ProfileItemType {
        return ProfileItemType(rawValue: itemType)! // Bang because itemType will always be present, without which a profile item is useless
    }
    
    func parseDataList(dataList: [[String:AnyObject]], _realm: Realm) {
        if itemTypeEnumValue() == .EscapeList {
            parseEscapesData(dataList, _realm: _realm)
        }
    }
    
    func parseEscapesData(escapesData: [[String:AnyObject]], _realm: Realm) {
        for eachEscapeData in escapesData {
            guard let id = eachEscapeData["id"] as? String, let name = eachEscapeData["name"] as? String, let escapeType = eachEscapeData["escape_type"] as? String else {
                continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(id, name: name, escapeType: escapeType, posterImage: eachEscapeData["poster_image"] as? String, year: eachEscapeData["year"] as? String, rating: eachEscapeData["escape_rating"] as? NSNumber, _realm: _realm)
            escapeDataList.append(escapeItem)
            
            
        }
    }
}
