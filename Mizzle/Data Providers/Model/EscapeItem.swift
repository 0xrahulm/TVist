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
    @objc dynamic var id:String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var posterImage:String?
    @objc dynamic var escapeType:String = ""
    @objc dynamic var year:String = ""
    @objc dynamic var rating:String = ""
    
    @objc dynamic var subTitle:String?
    @objc dynamic var createdBy:String?
    @objc dynamic var hasActed = false
    
    var isAlertSet:Bool = false
    
    var nextAirtime: Airtime?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isAlertSet", "nextAirtime"]
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
    
    class func createWithMediaItem(mediaItem: MediaItem, nextAirtime: Airtime?=nil) -> EscapeItem? {
        if let mediaId = mediaItem.id, let mediaName = mediaItem.name, let mediaType = mediaItem.type {
            let escapeItem = EscapeItem.addOrEditEscapeItem(mediaId, name: mediaName, escapeType: mediaType, posterImage: mediaItem.posterImage, year: mediaItem.year, rating: mediaItem.ratingNum, subTitle: nil, createdBy: nil, _realm: nil, nextAirtime: nil)
            escapeItem.nextAirtime = nextAirtime
            return escapeItem
        }
        
        return nil
    }
}
