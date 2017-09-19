//
//  MovieEscapeDataRealm.swift
//  Escape
//
//  Created by Ankit on 14/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation
import RealmSwift

class UserEscapeData: Object {
    
    @objc dynamic var userId : String? = nil
    
    @objc dynamic var sectionTitle : String? = nil
    @objc dynamic var sectionCount:NSNumber =        0
    @objc dynamic var escapeType : String? = nil
    
    @objc dynamic var id : String? = nil
    @objc dynamic var name : String? = nil
    @objc dynamic var posterImage : String? = nil
    @objc dynamic var year : String? = nil
    @objc dynamic var rating:NSNumber = 0.0
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
