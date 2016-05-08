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
import CoreData


protocol MyAccountDetailsProtocol : class {
    func recievedUserDetails (data : MyAccountItems?)
    func errorUserDetails()
}
protocol EscapeItemsProtocol : class {
    func recievedEscapeData(data : [MyAccountEscapeItems] , escape_type : EscapeType)
    func errorEscapeData()
}

class MyAccountDataProvider: CommonDataProvider {
    
    static let sharedDataProvider = MyAccountDataProvider()
    
    weak var myAccountDetailsDelegate : MyAccountDetailsProtocol?
    weak var escapeItemsDelegate : EscapeItemsProtocol?
    
    func getUserDetails(){
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserDetails, params: nil, delegate: self)
    }
    
    func getUserEscapes(escapeType : EscapeType){
        var params : [String:AnyObject] = [:]
        params["escape_type"] =  escapeType.rawValue
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserEscapes, params: params, delegate: self)
        
    }
    
    
    override func serviceSuccessfull(service: Service) {
        switch service.subServiveType! {
            
        case .GetUserDetails:
            if let data = service.outPutResponse as? [String:AnyObject]{
                self.parseUserDetails(data)
            }else{
                if self.myAccountDetailsDelegate != nil{
                    self.myAccountDetailsDelegate?.errorUserDetails()
                }
            }
            break
            
        case .GetUserEscapes:
            if let data = service.outPutResponse as? [[String:AnyObject]]{
                
                if let params = service.parameters {
                    if let escape_type = params["escape_type"] as? String{
                        self.parseEscapeData(data, escape_type: escape_type )
                    }
                }
                
            }else{
                if self.escapeItemsDelegate != nil{
                    self.escapeItemsDelegate?.errorEscapeData()
                }
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
            
        case .GetUserEscapes:
            if self.escapeItemsDelegate != nil{
                self.escapeItemsDelegate?.errorEscapeData()
            }
            break
            
        default:
            break
        }
    }
}

//MARK :- PARSING

extension MyAccountDataProvider {
    
    func parseUserDetails(dict : [String:AnyObject]){
        print (dict)
        
        var userData : MyAccountItems?
        
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
        var escapes_count = 0
        
        
        if let profileDetails = dict["profile_details"] as? [String:AnyObject]{
            if let uId = profileDetails["id"] as? String{
                id = uId
                ECUserDefaults.setCurrentUserId(uId)
                
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
            if let uGender = profileDetails["gender"] as? NSNumber{
                gender =  Gender(rawValue : Int(uGender))
            }
            if let picture = profileDetails["profile_picture"] as? String{
                profilePicture = picture
            }
        }
        
        if let uFollowers = dict["follower_count"] as? NSNumber{
            followers = uFollowers
        }
        if let uFollowing = dict["following_count"] as? NSNumber{
            following = uFollowing
        }
        if let uMovies = dict["movies"] as? NSNumber{
            movies_count = uMovies
            escapes_count = escapes_count + Int(uMovies)
            
        }
        if let uBooks = dict["books"] as? NSNumber{
            books_count =  uBooks
            escapes_count = escapes_count + Int(uBooks)
            
        }
        if let uShows = dict["shows"] as? NSNumber{
            tvShows_count = uShows
            escapes_count = escapes_count + Int(uShows)
            
            
        }
        User.createOrUpdateData(id, firstName: firstName, lastName: lastName, email: email, gender: gender?.rawValue, profilePicture: profilePicture, followers: followers, following: following, escapes_count: escapes_count)
        
        userData = MyAccountItems(id: id, firstName: firstName, lastName: lastName, email: email, gender: gender, profilePicture: profilePicture, followers: followers, following: following, movies_count: movies_count, books_count: books_count, tvShows_count: tvShows_count ,escapes_count : escapes_count)
        
        
        if let myAccountDetailsDelegate = myAccountDetailsDelegate{
            myAccountDetailsDelegate.recievedUserDetails(userData)
        }
        
    }
    
    func parseEscapeData(data : [[String:AnyObject]], escape_type: String){
        
        var escapeDataArray : [MyAccountEscapeItems] = []
        
        for dict in data{
            
            if let selectionTitle = dict["section_title"] as? String{
                if let count = dict["total_count"] as? NSNumber{
                    if let escapeArray = dict["data"] as? [[String:AnyObject]]{
                        
                        var escapeItems : [EscapeDataItems] = []
                        
                        for escapeItem in escapeArray{
                            var image : String?
                            
                            if let id = escapeItem["id"] as? String{
                                if let name = escapeItem["name"] as? String{
                                    if let type = escapeItem["escape_type"] as? String{
                                        if let escImage = escapeItem["poster_image"] as? String{
                                            image = escImage
                                        }
                                        escapeItems.append(EscapeDataItems(id: id, name: name, image: image, escapeType: EscapeType(rawValue: type)))
                                        
                                    }
                                }
                            }
                        }
                        escapeDataArray.append(MyAccountEscapeItems(title: selectionTitle, count: count, escapeData: escapeItems))
                    }
                }
            }
        }
        if self.escapeItemsDelegate != nil{
            self.escapeItemsDelegate?.recievedEscapeData(escapeDataArray , escape_type: EscapeType(rawValue: escape_type)!)
        }
        
    }
}



