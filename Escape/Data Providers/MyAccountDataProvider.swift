//
//  MyAccountDataProvider.swift
//  Escape
//
//  Created by Ankit on 06/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol MyAccountDetailsProtocol : class {
    func recievedUserDetails (data : MyAccountItems?)
    func errorUserDetails()
}

class MyAccountDataProvider: CommonDataProvider {
    
    static let sharedDataProvider = MyAccountDataProvider()
    
    weak var myAccountDetailsDelegate : MyAccountDetailsProtocol?
    
    func getUserDetails(){
     ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserDetails, params: nil, delegate: self)
    }
    
    
    override func serviceSuccessfull(service: Service) {
        switch service.subServiveType! {
        
        case .GetUserDetails:
            if let data = service.outPutResponse as? [String:AnyObject]{
                self.parseUserDetails(data)
            }
            break
        default:
            break
        }
    }
    
    override func serviceError(service: Service) {
        switch service.subServiveType! {
        
        case .GetUserDetails:
            if self.myAccountDetailsDelegate != nil{
                self.myAccountDetailsDelegate?.errorUserDetails()
            }
             break
            
        
        default:
            break
        }
    }
}
extension MyAccountDataProvider {
    
    func parseUserDetails(dict : [String:AnyObject]){
        print (dict)
        var userData : MyAccountItems?
        
        var id :            String?
        var firstName :     String?
        var lastName :      String?
        var email :         String?
        var gender :        String?
        var profilePicture :String?
        var followers :     NSNumber?
        var following :     NSNumber?
        var movies_count :  NSNumber?
        var books_count :   NSNumber?
        var tvShows_count : NSNumber?
        
        
        if let profileDetails = dict["profile_details"] as? [String:AnyObject]{
            if let uId = profileDetails["id"] as? String{
                id = uId
                
            }
            if let uFirst = profileDetails["first_name"] as? String{
                firstName = uFirst
                
            }
            if let uLast = profileDetails["last_name"] as? String{
                lastName = uLast
                
            }
            if let uEmail = profileDetails["email"] as? String{
                email = uEmail
            }
            if let uGender = profileDetails["gender"] as? String{
                gender = uGender
            }
        }
        if let picture = dict["profile_picture"] as? String{
            profilePicture = picture
        }
        if let uFollowers = dict["follower_count"] as? NSNumber{
            followers = uFollowers
        }
        if let uFollowing = dict["following_count"] as? NSNumber{
            following = uFollowing
        }
        if let uMovies = dict["movies"] as? NSNumber{
            movies_count = uMovies
            
        }
        if let uBooks = dict["books"] as? NSNumber{
            books_count =  uBooks
            
        }
        if let uShows = dict["shows"] as? NSNumber{
            tvShows_count = uShows
            
        }
        
        userData = MyAccountItems(id: id, firstName: firstName, lastName: lastName, email: email, gender: gender, profilePicture: profilePicture, followers: followers, following: following, movies_count: movies_count, books_count: books_count, tvShows_count: tvShows_count)
        
        if let myAccountDetailsDelegate = myAccountDetailsDelegate{
            myAccountDetailsDelegate.recievedUserDetails(userData)
        }
        
    }
}


