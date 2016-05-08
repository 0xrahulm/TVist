//
//  User+CoreDataProperties.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var user_id: String?
    @NSManaged var email: String?
    @NSManaged var gender: NSNumber?
    @NSManaged var profilePicture: String?
    @NSManaged var followers: NSNumber?
    @NSManaged var following: NSNumber?
    @NSManaged var escapes: NSNumber?

}
