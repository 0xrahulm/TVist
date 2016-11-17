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
    var firstName  = ""
    var lastName   = ""
    var email :         String?
    var gender :        Gender?
    var profilePicture: String?
    var followers:      NSNumber = 0
    var following:      NSNumber = 0
    var movies_count:   NSNumber?
    var books_count:    NSNumber?
    var tvShows_count:  NSNumber?
    var escapes_count:  NSNumber?
    var isFollow = false
    
    init(id : String?,firstName : String,lastName : String,email :String?,gender :        Gender?,profilePicture :String?,followers :NSNumber,following :NSNumber,movies_count :  NSNumber?,books_count : NSNumber?,tvShows_count : NSNumber?,escapes_count : NSNumber?) {
        
        self.id = id
        self.firstName = firstName
        self.lastName  = lastName
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
    
    init(dict : [String:AnyObject], userType : UserType?) {
        super.init()
        if let userType = userType{
            if userType == .Following{
                self.isFollow = true
            }
        }
        parseData(dict)
        
    }
    
    
    func parseData(profileDetails : [String:AnyObject]){
        
        var escapes_count = 0
        
        if let uId = profileDetails["id"] as? String{
            self.id = uId
            ECUserDefaults.setCurrentUserId(uId)
            
        }
        
        if let fName = profileDetails["first_name"] as? String{
            firstName = fName
        }
        
        if let lName = profileDetails["last_name"] as? String{
            lastName = lName
        }
        
        email = profileDetails["email"] as? String
        
        profilePicture = profileDetails["profile_picture"] as? String
        
        if let count = profileDetails["followers_count"] as? NSNumber{
            followers = count
        }
        
        if let count = profileDetails["following_count"] as? NSNumber{
            following = count
        }
        
        if let uGender = profileDetails["gender"] as? NSNumber{
            gender =  Gender(rawValue : Int(uGender))
        }
        
        if let uMovies = profileDetails["movies_count"] as? NSNumber{
            movies_count = uMovies
            escapes_count = escapes_count + Int(uMovies)
            
        }
        if let uBooks = profileDetails["books_count"] as? NSNumber{
            books_count =  uBooks
            escapes_count = escapes_count + Int(uBooks)
            
        }
        if let uShows = profileDetails["tv_shows_count"] as? NSNumber{
            tvShows_count = uShows
            escapes_count = escapes_count + Int(uShows)
            
        }
        
        if let isFollow = profileDetails["is_following"] as? Bool{
            self.isFollow = isFollow
        }
    }
}
