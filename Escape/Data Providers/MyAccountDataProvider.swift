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
    func receivedItemDesc(_ data : DescDataItems? ,id : String)
    func errorItemDescData()
}

protocol FollowersProtocol : class {
    func recievedFollowersData(_ data : [MyAccountItems] , userType : UserType)
    func error()
}

protocol EscapeListDataProtocol: class {
    func receivedEscapeListData(_ escapeData: [EscapeItem], page: Int?, escapeType: String?, escapeAction: String?, userId: String?)
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
    
    func getUserDetails(_ userId : String?){
        var params : [String:Any] = [:]
        if let userId = userId{
            params["user_id"] = userId
        }
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserDetails, params: params, delegate: self)
    }
    
    func getUserEscapes(_ escapeType: EscapeType, escapeAction: String?, userId: String?, page: Int?) {
        var params : [String:Any] = [:]
        
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
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserEscapes, params: params, delegate: self)
    }
    
    
    func getProfileList(_ listType: ProfileListType, forUserId:String?) -> Results<ProfileList> {
        
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
    
    func serviceResquestForProfileList(_ listType: ProfileListType, forUserId: String?) {
        var params:[String:Any] = ["list_type":listType.rawValue]
        if let forUserId = forUserId {
            params["user_id"] = forUserId
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetProfileList, params: params, delegate: self)
    }
    
    func getItemDesc(_ escapeType : EscapeType , id : String){
        var params : [String:Any] = [:]
        params["escape_id"] = id
        params["escape_type"] = escapeType.rawValue
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetItemDesc, params: params, delegate: self)
    }
    
    func logoutUser(){
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .LogoutUser, params: nil, delegate: self)
    }
    
    func getUserFollowing(_ id : String?){
        
        var params : [String:Any] = [:]
        
        if let id = id{
            params["user_id"] = id
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFollowing, params: params, delegate: self)
    }
    
    func getUserFollowers(_ id : String?){
        
        var params : [String:Any] = [:]
        
        if let id = id{
            params["user_id"] = id
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFollowers, params: params, delegate: self)
        
    }
    
    func getUserFriends(){
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetFriends, params: nil, delegate: self)
    }
    func postRecommend(_ escapeId : [String] , friendId : [String] , message : String?){
        
        var params : [String:Any] = [:]
        
        if let message = message {
            if message != ""{
                params["status"] = message
            }
        }
        
        params["to_user_ids"] = friendId
        params["escape_ids"] = escapeId
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .PostRecommend, params: params, delegate: self)
        
    }
    
    func getStoryLinkedObjects(_ storyId : String){
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetLinkedObjects, params:  ["story_id" : storyId], delegate: self)
    }
    
    func getSharedUsersOfStory(_ storyId : String){
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetSharedUsersOfStory, params:  ["story_id" : storyId], delegate: self)
    }
    
    
    override func serviceSuccessfull(_ service: Service) {
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
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.MyAccountObserver.rawValue), object: ["error" : "error"])
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
                    self.parseFollwingData(data, userType: .following)
                }
                break
                
            case .GetFollowers:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    self.parseFollwingData(data, userType: .followers)
                }
                break
                
            case .GetFriends:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    self.parseFollwingData(data, userType: .friends)
                }
                break
            case .PostRecommend:
                Logger.debug("recommendation posted 200 OK")
                break
                
            case .GetLinkedObjects:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    self.parseFollwingData(data, userType: .fbFriends)
                }
                break
                
            case .GetSharedUsersOfStory:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    self.parseFollwingData(data, userType: .sharedUsersOfStory)
                }
                break
                
            default:
                break
            }
        }
    }
    
    
    
    override func serviceError(_ service: Service) {
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
                
            case .GetUserDetails:
                if self.myAccountDetailsDelegate != nil{
                    self.myAccountDetailsDelegate?.errorUserDetails()
                }
                break
                
            case .GetUserEscapes:
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.MyAccountObserver.rawValue), object: ["error" : "error"])
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
                
            case .GetLinkedObjects:
                if followersDelegate != nil{
                    followersDelegate?.error()
                }
                break
                
            case .GetSharedUsersOfStory:
                if followersDelegate != nil{
                    followersDelegate?.error()
                }
                break
                
            default:
                break
            }
        }
    }
}

//MARK :- PARSING

extension MyAccountDataProvider {
    
    func updateProfileListWith(_ data: [String: AnyObject]) {
        guard let listType = data["list_type"] as? String,
            let _ = ProfileListType(rawValue: listType),
            let userId = data["user_id"] as? String,
            let listData = data["list_data"] as? [[String:AnyObject]] else {
                return
        }
        
        
        if let currentUser = currentUser, let currentUserId = currentUser.id, currentUserId == userId {
            
            RealmDataVader.sharedVader.writeOrUpdateProfileList(userId, type: listType, listData: listData)
        } else {
            
            let profileList = ProfileList()
            profileList.type = listType
            profileList.userId = userId
            profileList.parseDataNoRealm(listData)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.OtherUserProfileListFetchObserver.rawValue), object: nil, userInfo: ["type":listType, "data":profileList])
        }
    }
    
    func parseUserDetails(_ dict: [String:AnyObject], userId: String?){
        Logger.debug("User Details :\(dict)")
        
        let userData: MyAccountItems = MyAccountItems(dict: dict, userType: nil)
        
        if userId == nil {  // save in case of self only.
            saveUserDataToRealm(userData)
            
            
            if self.myAccountDetailsDelegate != nil {
                self.myAccountDetailsDelegate!.recievedUserDetails()
            }
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.GetProfileDetailsObserver.rawValue), object: nil, userInfo: ["userData": userData])
        }
        
    }
    
    func parseEscapeListData(_ data: [[String:AnyObject]], escape_type: String, escapeAction: String?, userId: String?, page: Int?) {
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
    func oldParseEscapeData(_ data: [[String:AnyObject]], escape_type: String , userId: String?) {
        
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
        var postableUserInfo:[String:Any] = ["data" : escapeDataArray, "type":escape_type]
        if let userId = userId {
            postableUserInfo["userId"] = userId
        } else {
            saveEscapesToRealm(escapeDataArray, escapeType: EscapeType(rawValue: escape_type)!)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.MyAccountObserver.rawValue), object: nil, userInfo: postableUserInfo)
        
    }
    
    func parseDescData(_ dict : [String:AnyObject], id : String){
        
        var dataItems : DescDataItems?
        
        dataItems = DescDataItems(dict: dict)
        
        if self.itemDescDelegate != nil{
            self.itemDescDelegate?.receivedItemDesc(dataItems, id : id)
        }
        
    }
    
    func parseFollwingData(_ data : [[String:AnyObject]] , userType : UserType){
        
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
    func saveUserDataToRealm(_ userItem : MyAccountItems?){
        
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
            
            userData.escape_count = userItem.escapes_count.intValue
            
            
            self.currentUser = userData
            
            let uiRealm  = try! Realm()
            try! uiRealm.write({
                uiRealm.add(userData , update: true)
            })
        }
    }
    
    func saveEscapesToRealm(_ escapeDataArray : [MyAccountEscapeItem] , escapeType : EscapeType){
        
        for item in escapeDataArray{
            
            if let currentUserId = ECUserDefaults.getCurrentUserId(){
                
                if let escapeItems = item.escapeData{
                    
                    for escapeItem in escapeItems{
                        
                        let escapeData = UserEscapeData()
                        
                        escapeData.userId = currentUserId
                        
                        escapeData.sectionTitle = item.title
                        
                        if let count = item.count{
                            escapeData.sectionCount = count
                        }
                        escapeData.id = escapeItem.id
                        escapeData.name = escapeItem.name
                        escapeData.posterImage = escapeItem.image
                        escapeData.escapeType = escapeItem.escapeType?.rawValue
                        escapeData.year = escapeItem.year
                        if let rating = escapeItem.escapeRating{
                            escapeData.rating = rating
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





