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
    var escapes_count:  NSNumber = 0
    var isFollow = false
    
    init(id : String?,firstName : String,lastName : String,email :String?,gender :        Gender?,profilePicture :String?,followers :NSNumber,following :NSNumber,escapes_count : NSNumber?) {
        
        self.id = id
        self.firstName = firstName
        self.lastName  = lastName
        self.email = email
        self.gender = gender
        self.profilePicture = profilePicture
        self.followers = followers
        self.following = following
        
        if let escapes_count = escapes_count {
            self.escapes_count = escapes_count
        }
        
    }
    
    init(dict : [String:AnyObject], userType : UserType?) {
        super.init()
        if let userType = userType{
            if userType == .following{
                self.isFollow = true
            }
        }
        parseData(dict)
        
    }
    
    
    func parseData(_ profileDetails : [String:AnyObject]){
        
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
        
        if let escapesCount = profileDetails["escapes_count"] as? NSNumber{
            self.escapes_count = escapesCount
            
        }
        
        if let isFollow = profileDetails["is_following"] as? Bool{
            self.isFollow = isFollow
        }
    }
}
