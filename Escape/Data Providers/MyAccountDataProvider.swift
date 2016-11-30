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
import RealmSwift

protocol MyAccountDetailsProtocol : class {
    func recievedUserDetails()
    func errorUserDetails()
}

protocol ItemDescProtocol : class {
    func receivedItemDesc(data : DescDataItems? ,id : String)
    func errorItemDescData()
}

protocol FollowersProtocol : class {
    func recievedFollowersData(data : [MyAccountItems] , userType : UserType)
    func error()
}

protocol EscapeListDataProtocol: class {
    func receivedEscapeListData(escapeData: [EscapeItem], page: Int?, escapeType: String?, escapeAction: String?, userId: String?)
    func failedToReceiveData()
}

class MyAccountDataProvider: CommonDataProvider {
    
    static let sharedDataProvider = MyAccountDataProvider()
    
    weak var myAccountDetailsDelegate : MyAccountDetailsProtocol?
    weak var itemDescDelegate : ItemDescProtocol?
    weak var followersDelegate : FollowersProtocol?
    weak var escapeListDataDelegate: EscapeListDataProtocol?
    
    var currentUser:UserData?
    
    override init() {
        super.init()
        
        setCurrentUser()
    }
    
    func setCurrentUser(){
        
        if let currentUserId = ECUserDefaults.getCurrentUserId() {
            currentUser = RealmDataVader.sharedVader.getUserById(currentUserId)
        }
    }
    
    func getUserDetails(userId : String?){
        var params : [String:AnyObject] = [:]
        if let userId = userId{
            params["user_id"] = userId
        }
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserDetails, params: params, delegate: self)
    }
    
    func getUserEscapes(escapeType: EscapeType, escapeAction: String?, userId: String?, page: Int?) {
        var params : [String:AnyObject] = [:]
        
        params["escape_type"] =  escapeType.rawValue
        
        if let userId = userId {
            params["user_id"] = userId
        }
        
        if let page = page {
            params["page"] = page
        }
        
        if let escapeAction = escapeAction {
            params["escape_action"] = escapeAction
        }
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserEscapes, params: params, delegate: self)
    }
    
    
    func getProfileList(listType: ProfileListType, forUserId:String?) -> Results<ProfileList> {
        
        serviceResquestForProfileList(listType, forUserId: forUserId)
        
        var userId = ""
        
        if let currentUser = currentUser, let currentUserId = currentUser.id {
            userId = currentUserId
        }
        
        if let forUserId = forUserId {
            userId = forUserId
        }
        
        return RealmDataVader.sharedVader.getProfileListData(listType, userId: userId)
    }
    
    func serviceResquestForProfileList(listType: ProfileListType, forUserId: String?) {
        var params:[String:AnyObject] = ["list_type":listType.rawValue]
        if let forUserId = forUserId {
            params["user_id"] = forUserId
        }
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetProfileList, params: params, delegate: self)
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
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFollowing, params: params, delegate: self)
    }
    
    func getUserFollowers(id : String?){
        
        var params : [String:AnyObject] = [:]
        
        if let id = id{
            params["user_id"] = id
        }
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFollowers, params: params, delegate: self)
        
    }
    
    func getUserFriends(){
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFriends, params: nil, delegate: self)
    }
    func postRecommend(escapeId : [String] , friendId : [String] , message : String?){
        
        var params : [String:AnyObject] = [:]
        
        if let message = message {
            if message != ""{
                params["status"] = message
            }
        }
        
        params["to_user_ids"] = friendId
        params["escape_ids"] = escapeId
        
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .PostRecommend, params: params, delegate: self)
        
    }
    
    
    override func serviceSuccessfull(service: Service) {
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
                
            case .GetProfileList:
                if let profileListData = service.outPutResponse as? [String:AnyObject] {
                    updateProfileListWith(profileListData)
                }
                break
                
            case .GetUserDetails:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    if let params = service.parameters{
                        self.parseUserDetails(data, userId: params["user_id"] as? String)
                    }else{
                        self.parseUserDetails(data, userId: nil)
                        
                    }
                    
                }else{
                    if self.myAccountDetailsDelegate != nil{
                        self.myAccountDetailsDelegate?.errorUserDetails()
                    }
                }
                break
                
            case .GetUserEscapes:
                if let data = service.outPutResponse as? [[String:AnyObject]] {
                    
                    if let params = service.parameters {
                        if let escape_type = params["escape_type"] as? String {
                            self.parseEscapeListData(data, escape_type: escape_type, escapeAction: params["escape_action"] as? String, userId: params["user_id"] as? String, page: params["page"] as? Int)
                        }
                    }
                    
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.MyAccountObserver.rawValue, object: ["error" : "error"])
                }
                break
                
            case .LogoutUser:
                ScreenVader.sharedVader.performLogout()
                break
                
            case .GetItemDesc:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    if let params = service.parameters{
                        if let id = params["escape_id"] as? String{
                            self.parseDescData(data , id : id)
                        }
                    }
                    
                }else{
                    if self.itemDescDelegate != nil {
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
                
            case .GetFriends:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    self.parseFollwingData(data, userType: .Friends)
                }
                break
            case .PostRecommend:
                Logger.debug("recommendation posted 200 OK")
                break
                
            default:
                break
            }
        }
    }
    
    
    
    override func serviceError(service: Service) {
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
                
            case .GetUserDetails:
                if self.myAccountDetailsDelegate != nil{
                    self.myAccountDetailsDelegate?.errorUserDetails()
                }
                break
                
            case .GetUserEscapes:
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.MyAccountObserver.rawValue, object: ["error" : "error"])
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
                
            case .GetFriends:
                if followersDelegate != nil{
                    followersDelegate?.error()
                }
                
                break
            
            case .PostRecommend:
                Logger.debug("Error in Recommedation")
                break
                
            default:
                break
            }
        }
    }
}

//MARK :- PARSING

extension MyAccountDataProvider {
    
    func updateProfileListWith(data: [String: AnyObject]) {
        guard let listType = data["list_type"] as? String,
            let _ = ProfileListType(rawValue: listType),
            let userId = data["user_id"] as? String,
            let listData = data["list_data"] as? [[String:AnyObject]] else {
                return
        }
        
        
        
        RealmDataVader.sharedVader.writeOrUpdateProfileList(userId, type: listType, listData: listData)
    }
    
    func parseUserDetails(dict: [String:AnyObject], userId: String?){
        Logger.debug("User Details :\(dict)")
        
        let userData: MyAccountItems = MyAccountItems(dict: dict, userType: nil)
        
        if userId == nil {  // save in case of self only.
            saveUserDataToRealm(userData)
            
            
            if self.myAccountDetailsDelegate != nil {
                self.myAccountDetailsDelegate!.recievedUserDetails()
            }
            
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.GetProfileDetailsObserver.rawValue, object: nil, userInfo: ["userData": userData])
        }
        
    }
    
    func parseEscapeListData(data: [[String:AnyObject]], escape_type: String, escapeAction: String?, userId: String?, page: Int?) {
        var dataArray:[EscapeItem] = []
        
        for eachItem in data {
            guard let itemTitle = eachItem["name"] as? String,
                let itemId = eachItem["id"] as? String,
                let escapeType = eachItem["escape_type"] as? String else {
                    continue
            }
            
            dataArray.append(EscapeItem.addOrEditEscapeItem(itemId, name: itemTitle, escapeType: escapeType, posterImage: eachItem["poster_image"] as? String, year: eachItem["year"] as? String, rating: eachItem["rating"] as? NSNumber, subTitle: eachItem["subtitle"] as? String, createdBy: eachItem["creator"] as? String, _realm: nil))
        }
        
        if let escapeListDataDelegate = escapeListDataDelegate {
            escapeListDataDelegate.receivedEscapeListData(dataArray, page: page, escapeType: escape_type, escapeAction: escapeAction, userId: userId)
        }
    }
    
    
    // This is to be removed, has already been replaced
    func oldParseEscapeData(data: [[String:AnyObject]], escape_type: String , userId: String?) {
        
        var escapeDataArray : [MyAccountEscapeItem] = []
        
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
                        escapeDataArray.append(MyAccountEscapeItem(title: selectionTitle, count: count, escapeData: escapeItems))
                    }
                }
            }
        }
        var postableUserInfo:[String:AnyObject] = ["data" : escapeDataArray, "type":escape_type]
        if let userId = userId {
            postableUserInfo["userId"] = userId
        } else {
            saveEscapesToRealm(escapeDataArray, escapeType: EscapeType(rawValue: escape_type)!)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.MyAccountObserver.rawValue, object: nil, userInfo: postableUserInfo)
        
    }
    
    func parseDescData(dict : [String:AnyObject], id : String){
        
        var dataItems : DescDataItems?
        
        dataItems = DescDataItems(dict: dict)
        
        if self.itemDescDelegate != nil{
            self.itemDescDelegate?.receivedItemDesc(dataItems, id : id)
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
            
            userData.movies_count = userItem.movies_count.integerValue
            
            userData.books_count = userItem.books_count.integerValue
            
            userData.tvShows_count = userItem.tvShows_count.integerValue
            
            userData.escape_count = userItem.escapes_count.integerValue
            
            
            self.currentUser = userData
            
            let uiRealm  = try! Realm()
            try! uiRealm.write({
                uiRealm.add(userData , update: true)
            })
        }
    }
    
    func saveEscapesToRealm(escapeDataArray : [MyAccountEscapeItem] , escapeType : EscapeType){
        
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





