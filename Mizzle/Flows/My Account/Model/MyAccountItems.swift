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
    var trackingsCount:  NSNumber = 0
    var alertsCount: NSNumber = 0
    var seenCount: NSNumber = 0
    var userType: String = "g"
    var loggedInUsing:LoggedInUsing = .Guest
    var isFollow = false
    
    func userTypeEnum() -> UserType {
        
        if let userTypeVal = UserType(rawValue: self.userType) {
            return userTypeVal
        }
        
        return .Guest
    }
    
    func isPremium() -> Bool {
        return userTypeEnum() == .Premium
    }
    
    
    init(id : String?,firstName : String,lastName : String,email :String?,gender: Gender?,profilePicture :String?,followers :NSNumber,following :NSNumber,escapes_count : NSNumber?) {
        
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
    
    init(dict : [String:Any], userType : UserType?) {
        super.init()
        if let userType = userType{
        }
        parseData(dict)
        
    }
    
    
    func parseData(_ profileDetails : [String:Any]){
        
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
        
        if let loggedInUsing = profileDetails["logged_in_using"] as? Int, let loggedInUsingVal = LoggedInUsing(rawValue: loggedInUsing) {
            self.loggedInUsing = loggedInUsingVal
        }
        
        if let trackingsCount = profileDetails["trackings_count"] as? NSNumber {
            self.trackingsCount = trackingsCount
        }
        
        if let alertsCount = profileDetails["alerts_count"] as? NSNumber {
            self.alertsCount = alertsCount
        }
        
        if let seenCount = profileDetails["seen_count"] as? NSNumber {
            self.seenCount = seenCount
        }
        
        if let userType = profileDetails["type"] as? String {
            self.userType = userType
        }
    }
}
