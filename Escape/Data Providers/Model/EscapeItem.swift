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
    
    var isTracking:Bool = false
    
    var nextAirtime: Airtime?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isTracking", "nextAirtime"]
    }
    
    class func addOrEditEscapeItem(_ id: String, name: String, escapeType:String, posterImage: String?, year: String?, rating: NSNumber?, subTitle: String?, createdBy: String?, _realm: Realm?, nextAirtime: [String:Any]?) -> EscapeItem {
        
        if let _realm = _realm, let escapeItem =  _realm.object(ofType: EscapeItem.self, forPrimaryKey: id) {
            
            
            escapeItem.updateEscapeName(name, escapeType: escapeType, posterImage: posterImage, year: year, rating: rating, subTitle: subTitle, createdBy: createdBy, nextAirtime: nextAirtime)
            return escapeItem
        } else {
            
            let escapeItem = EscapeItem()
            escapeItem.id   = id
            
            escapeItem.updateEscapeName(name, escapeType: escapeType, posterImage: posterImage, year: year, rating: rating, subTitle: subTitle, createdBy: createdBy, nextAirtime: nextAirtime)
            return escapeItem
        }
        
    }
    
    func updateEscapeName(_ name: String, escapeType:String, posterImage: String?, year: String?, rating: NSNumber?, subTitle: String?, createdBy: String?, nextAirtime: [String:Any]?) {
        
        
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
        
        if let nextAirtime = nextAirtime {
            self.nextAirtime = Airtime.createAirtime(nextAirtime)
        }
    }
    
    func escapeTypeVal() -> EscapeType {
        return EscapeType(rawValue: self.escapeType)!
    }
}
