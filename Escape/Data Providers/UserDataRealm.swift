//
//  UserDataRealm.swift
//  Escape
//
//  Created by Ankit on 10/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation
import RealmSwift

class UserData: Object {
    
    dynamic var id :            String? = nil
    dynamic var firstName :     String? = nil
    dynamic var lastName :      String? = nil
    dynamic var email :         String? = nil
    dynamic var gender = 1
    dynamic var profilePicture :String? = nil
    dynamic var followers =             0
    dynamic var following =             0
    dynamic var movies_count =          0
    dynamic var books_count =           0
    dynamic var tvShows_count =         0
    dynamic var escape_count =          0
    
    let escapeList = List<UserEscapeData>()
    
    
    dynamic var createdAt =     NSDate()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
