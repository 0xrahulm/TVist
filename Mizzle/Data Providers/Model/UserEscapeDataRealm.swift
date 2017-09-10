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
    
    dynamic var userId : String? = nil
    
    dynamic var sectionTitle : String? = nil
    dynamic var sectionCount:NSNumber =        0
    dynamic var escapeType : String? = nil
    
    dynamic var id : String? = nil
    dynamic var name : String? = nil
    dynamic var posterImage : String? = nil
    dynamic var year : String? = nil
    dynamic var rating:NSNumber = 0.0
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
