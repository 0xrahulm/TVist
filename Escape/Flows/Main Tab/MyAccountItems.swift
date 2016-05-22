//
//  MyAccountItems.swift
//  Escape
//
//  Created by Ankit on 06/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit


class MyAccountItems: NSObject {
    
    var id :            String?
    var firstName :     String?
    var lastName :      String?
    var email :         String?
    var gender :        Gender?
    var profilePicture :String?
    var followers :     NSNumber?
    var following :     NSNumber?
    var movies_count :  NSNumber?
    var books_count :   NSNumber?
    var tvShows_count : NSNumber?
    var escapes_count : NSNumber?
    
    init(id: String?,firstName:String?,lastName:String?,email:String?,gender:Gender?,profilePicture:String?,followers:NSNumber?,following:NSNumber?,movies_count :  NSNumber?,books_count:NSNumber?,tvShows_count : NSNumber?,escapes_count : NSNumber?) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.gender = gender
        self.profilePicture = profilePicture
        self.followers = followers
        self.following = following
        self.movies_count = movies_count
        self.books_count = books_count
        self.tvShows_count = tvShows_count
        self.escapes_count = escapes_count
        
    }
    

}
