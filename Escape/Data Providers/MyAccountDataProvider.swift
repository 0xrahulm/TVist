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
import RealmSwift


protocol MyAccountDetailsProtocol : class {
    func recievedUserDetails (data : MyAccountItems?)
    func errorUserDetails()
}
protocol EscapeItemsProtocol : class {
    func recievedEscapeData(data : [MyAccountEscapeItems] , escape_type : EscapeType)
    func errorEscapeData()
}
protocol ItemDescProtocol : class {
    func receivedItemDesc(data : DescDataItems?)
    func errorItemDescData()
}
protocol FollowersProtocol : class {
    func recievedFollowersData(data : [MyAccountItems] , userType : UserType)
    func error()
}

class MyAccountDataProvider: CommonDataProvider {
    
    static let sharedDataProvider = MyAccountDataProvider()
    
    weak var myAccountDetailsDelegate : MyAccountDetailsProtocol?
    weak var escapeItemsDelegate : EscapeItemsProtocol?
    weak var itemDescDelegate : ItemDescProtocol?
    weak var followersDelegate : FollowersProtocol?
    
    var currentUser:UserData?
    
    override init() {
        super.init()
        
        setCurrentUser()
        
    }
    
    func setCurrentUser(){
        
        if let currentUserId = ECUserDefaults.getCurrentUserId(){
            
            let predicate = NSPredicate(format: "id == %@", currentUserId)
            
            do {
                if let user = try Realm().objects(UserData).filter(predicate).first{
                    
                    currentUser = user
                
                }
                
            } catch let  error as NSError{
                print(error.userInfo)
            }
        }
    }
    
    func getUserDetails(){
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserDetails, params: nil, delegate: self)
    }
    
    func getUserEscapes(escapeType : EscapeType){
        var params : [String:AnyObject] = [:]
        params["escape_type"] =  escapeType.rawValue
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserEscapes, params: params, delegate: self)
        
    }
    
    func getItemDesc(escapeType : EscapeType , id : String){
        var params : [String:AnyObject] = [:]
        params["escape_id"] = id
        params["escape_type"] = escapeType.rawValue
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetItemDesc, params: params, delegate: self)
        
    }
    
    func logoutUser(){
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .LogoutUser, params: nil, delegate: self)
    }
    
    func getUserFollowing(id : String?){
        
        var params : [String:AnyObject] = [:]
        
        if let id = id{
          params["user_id"] = id
        }
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFollowing, params: nil, delegate: self)
        
    }
    
    func getUserFollowers(id : String?){
        
        var params : [String:AnyObject] = [:]
        
        if let id = id{
            params["user_id"] = id
        }
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFollowers, params: nil, delegate: self)
        
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
            
        case .LogoutUser:
            ScreenVader.sharedVader.performLogout()
            break
            
        case .GetItemDesc:
            if let data = service.outPutResponse as? [String:AnyObject]{
                self.parseDescData(data)
            }else{
                if self.itemDescDelegate != nil{
                    self.itemDescDelegate?.errorItemDescData()
                }
            }
            break
            
        case .GetFollowing:
            if let data = service.outPutResponse as? [[String:AnyObject]]{
                self.parseFollwingData(data, userType: .Following)
            }
            break
        
        case .GetFollowers:
            if let data = service.outPutResponse as? [[String:AnyObject]]{
                self.parseFollwingData(data, userType: .Followers)
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
            
        case .LogoutUser:
            
            break
            
        case .GetItemDesc:
            if self.itemDescDelegate != nil{
                self.itemDescDelegate?.errorItemDescData()
            }
            
            break
            
        case .GetFollowing:
            if followersDelegate != nil{
                followersDelegate?.error()
            }
            
            break
            
        case .GetFollowers:
            if followersDelegate != nil{
                followersDelegate?.error()
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
        print ("User Details :\(dict)")
        
        var userData : MyAccountItems?
        
        userData = MyAccountItems(dict : dict,userType: nil)
        
        saveUserDataToRealm(userData)
        
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
                            var rating : NSNumber?
                            var year : String?
                            
                            if let id = escapeItem["id"] as? String{
                                if let name = escapeItem["name"] as? String{
                                    if let type = escapeItem["escape_type"] as? String{
                                        if let escImage = escapeItem["poster_image"] as? String{
                                            image = escImage
                                        }
                                        if let escapeRating = escapeItem["escape_rating"] as? NSNumber{
                                            rating = escapeRating
                                        }
                                        if let releaseYear = escapeItem["year"] as? String{
                                            year = releaseYear
                                        }
                                        escapeItems.append(EscapeDataItems(id: id, name: name, image: image, escapeType: EscapeType(rawValue: type), escapeRating: rating, year: year))
                                        
                                    }
                                }
                            }
                        }
                        escapeDataArray.append(MyAccountEscapeItems(title: selectionTitle, count: count, escapeData: escapeItems))
                    }
                }
            }
        }
        
        saveEscapesToRealm(escapeDataArray , escapeType: EscapeType(rawValue: escape_type)!)
        
        if self.escapeItemsDelegate != nil{
            self.escapeItemsDelegate?.recievedEscapeData(escapeDataArray , escape_type: EscapeType(rawValue: escape_type)!)
        }
        
    }
    
    func parseDescData(dict : [String:AnyObject]){
        
        var dataItems : DescDataItems?
        
        dataItems = DescDataItems(dict: dict)
        
        if self.itemDescDelegate != nil{
            self.itemDescDelegate?.receivedItemDesc(dataItems)
        }
        
    }
    
    func parseFollwingData(data : [[String:AnyObject]] , userType : UserType){
        
        var userItems : [MyAccountItems] = []
        for item in data{
            
            userItems.append(MyAccountItems(dict: item, userType: userType))
            
        }
        
        if followersDelegate != nil{
            followersDelegate?.recievedFollowersData(userItems, userType: userType)
        }
    }
}

//MARK :- Persist Data
extension MyAccountDataProvider{
    func saveUserDataToRealm(userItem : MyAccountItems?){
        
        if let userItem = userItem{
            
            let userData = UserData()
            userData.id = userItem.id
            userData.firstName  = userItem.firstName
            userData.lastName = userItem.lastName
            userData.email = userItem.email
            if let gender = userItem.gender?.rawValue{
                userData.gender = gender
            }
            
            userData.profilePicture = userItem.profilePicture
            
            userData.followers = Int(userItem.followers)
            
            userData.following = Int(userItem.following)
            
            if let movies = userItem.movies_count{
                userData.movies_count = Int(movies)
            }
            if let books = userItem.books_count{
                userData.books_count = Int(books)
            }
            if let tvShows = userItem.tvShows_count{
                userData.tvShows_count = Int(tvShows)
            }
            if let escape = userItem.escapes_count{
                userData.escape_count = Int(escape)
            }
            
            self.currentUser = userData
            
            let uiRealm  = try! Realm()
            try! uiRealm.write({
                uiRealm.add(userData , update: true)
            })
            
            
        }
        
    }
    
    func saveEscapesToRealm(escapeDataArray : [MyAccountEscapeItems] , escapeType : EscapeType){
        
        for item in escapeDataArray{
            
            if let currentUserId = ECUserDefaults.getCurrentUserId(){
                
                if let escapeItems = item.escapeData{
                    
                    for escapeItem in escapeItems{
                        
                        let escapeData = UserEscapeData()
                        
                        escapeData.userId = currentUserId
                        
                        escapeData.sectionTitle = item.title
                        
                        if let count = item.count{
                            escapeData.sectionCount = Int(count)
                        }
                        escapeData.id = escapeItem.id
                        escapeData.name = escapeItem.name
                        escapeData.posterImage = escapeItem.image
                        escapeData.escapeType = escapeItem.escapeType?.rawValue
                        escapeData.year = escapeItem.year
                        if let rating = escapeItem.escapeRating{
                            escapeData.rating = Double(rating)
                        }
                        
                        
                        let uiRealm = try! Realm()
                        try! uiRealm.write({
                            uiRealm.add(escapeData ,update: true)
                            self.currentUser?.escapeList.append(escapeData)
                        })
                        
                    }
                    
                }

                
            }
            
        }
        
        
    }
    
}





