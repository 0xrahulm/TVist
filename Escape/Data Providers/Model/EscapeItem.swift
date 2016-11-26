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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func addOrEditEscapeItem(id: String, name: String, escapeType:String, posterImage: String?, year: String?, rating: NSNumber?, _realm: Realm) -> EscapeItem {
        
        if let escapeItem = _realm.objectForPrimaryKey(EscapeItem.self, key: id) {
            
            escapeItem.updateEscapeName(name, escapeType: escapeType, posterImage: posterImage, year: year, rating: rating)
            return escapeItem
        } else {
            
            let escapeItem = EscapeItem()
            escapeItem.id   = id
            
            escapeItem.updateEscapeName(name, escapeType: escapeType, posterImage: posterImage, year: year, rating: rating)
            return escapeItem
        }
        
    }
    
    func updateEscapeName(name: String, escapeType:String, posterImage: String?, year: String?, rating: NSNumber?) {
        
        
        self.name = name
        self.escapeType  = escapeType
        self.posterImage = posterImage
        
        
        if let year = year {
            self.year = year
        }
        
        if let rating = rating {
            self.rating = String(format: "%.1f", rating.floatValue)
        }
    }
}
