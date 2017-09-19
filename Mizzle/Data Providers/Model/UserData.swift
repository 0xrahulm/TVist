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
    
    @objc dynamic var id :            String? = nil
    @objc dynamic var firstName :     String = ""
    @objc dynamic var lastName :      String = ""
    @objc dynamic var email :         String? = nil
    @objc dynamic var gender = 1
    @objc dynamic var profilePicture :String? = nil
    @objc dynamic var followers =             0
    @objc dynamic var following =             0
    @objc dynamic var movies_count =          0
    @objc dynamic var books_count =           0
    @objc dynamic var tvShows_count =         0
    @objc dynamic var escape_count =          0
    @objc dynamic var track_count  = 0
    @objc dynamic var alerts_count = 0
    @objc dynamic var seen_count = 0
    @objc dynamic var userType:String  = "g"
    
    let escapeList = List<UserEscapeData>()
    
    
    @objc dynamic var createdAt =     Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func userTypeEnum() -> UserType {
        
        if let userTypeVal = UserType(rawValue: self.userType) {
            return userTypeVal
        }
        
        return .Guest
    }
    
    func isPremium() -> Bool {
        return userTypeEnum() == .Premium
    }
    
}
