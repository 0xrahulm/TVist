//
//  EscapeItem.swift
//  Escape
//
//  Created by Rahul Meena on 23/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import RealmSwift

final class EscapeItem: Object {
    dynamic var id:String = ""
    dynamic var name:String = ""
    dynamic var posterImage:String?
    dynamic var escapeType:String = ""
    dynamic var year:String = ""
    dynamic var rating:String = ""
    
    dynamic var subTitle:String?
    dynamic var createdBy:String?
    dynamic var hasActed = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func addOrEditEscapeItem(id: String, name: String, escapeType:String, posterImage: String?, year: String?, rating: NSNumber?, subTitle: String?, createdBy: String?, _realm: Realm?) -> EscapeItem {
        
        if let _realm = _realm, let escapeItem = _realm.objectForPrimaryKey(EscapeItem.self, key: id) {
            
            escapeItem.updateEscapeName(name, escapeType: escapeType, posterImage: posterImage, year: year, rating: rating, subTitle: subTitle, createdBy: createdBy)
            return escapeItem
        } else {
            
            let escapeItem = EscapeItem()
            escapeItem.id   = id
            
            escapeItem.updateEscapeName(name, escapeType: escapeType, posterImage: posterImage, year: year, rating: rating, subTitle: subTitle, createdBy: createdBy)
            return escapeItem
        }
        
    }
    
    func updateEscapeName(name: String, escapeType:String, posterImage: String?, year: String?, rating: NSNumber?, subTitle: String?, createdBy: String?) {
        
        
        self.name = name
        self.escapeType  = escapeType
        self.posterImage = posterImage
        self.subTitle = subTitle
        self.createdBy = createdBy
        
        if let year = year {
            self.year = year
        }
        
        if let rating = rating {
            self.rating = String(format: "%.1f", rating.floatValue)
        }
    }
    
    func escapeTypeVal() -> EscapeType {
        return EscapeType(rawValue: self.escapeType)!
    }
}
