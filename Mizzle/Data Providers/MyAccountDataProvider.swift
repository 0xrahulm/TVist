//
//  MyAccountDataProvider.swift
//  Escape
//
//  Created by Ankit on 06/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire
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

protocol SimilarEscapesProtocol:class {
    func receivedSimilarEscapes(_ escapeData: [EscapeItem], page: Int?)
    func failedToReceivedData()
}

protocol RelatedPeopleProtocol:class {
    func receivedRelatedPeople(_ relatedPeople: [MyAccountItems], page: Int?)
    func failedToReceivedData()
}

protocol EscapeActionProtocol:class {
    func receivedActionForEscape(escapeId: String, escapeAction: EscapeAddActions)
    func failedToFetchAction()
}

class MyAccountDataProvider: CommonDataProvider {
    
    static let sharedDataProvider = MyAccountDataProvider()
    
    weak var myAccountDetailsDelegate : MyAccountDetailsProtocol?
    weak var itemDescDelegate : ItemDescProtocol?
    weak var similarEscapesDelegate: SimilarEscapesProtocol?
    weak var relatedPeopleDelegate: RelatedPeopleProtocol?
    weak var followersDelegate : FollowersProtocol?
    weak var escapeActionDelegate: EscapeActionProtocol?
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
        
        if let currentUser = self.currentUser, currentUser.isPremium(), IAPVader.sharedVader.hasReceiptData {
           IAPVader.sharedVader.verifyReceiptData()
        } else {
            ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserDetails, params: params, delegate: self)
        }
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
    
    func updateProfilePicture(pictureName: String) {
        
        ServiceCall(.put, serviceType: .ServiceTypePrivateApi, subServiceType: .PutProfilePicture, params: ["picture_name":pictureName], delegate: self)
    }
    
    func updateEmail(email: String) {
        RealmDataVader.sharedVader.updateEmailForCurrentUser(email: email)
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UpdateEmail, params: ["email": email], delegate: self)
    }
    
    func updateFirstName(firstName: String) {
        RealmDataVader.sharedVader.updateFirstNameForCurrentUser(firstName: firstName)
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UpdateFirstName, params: ["first_name": firstName], delegate: self)
    }
    
    func updateLastName(lastName: String) {
        RealmDataVader.sharedVader.updateLastNameForCurrentUser(lastName: lastName)
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UpdateLastName, params: ["last_name": lastName], delegate: self)
    }

    func updatePassword(password: String) {
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UpdatePassword, params: ["password": password], delegate: self)
    }
    
    func removeEscape(escapeId: String) {
        ServiceCall(.delete, serviceType: .ServiceTypePrivateApi, subServiceType: .DeleteEscape, params: ["escape_id":escapeId], delegate: self)
    }
    
    func updateEscape(escapeId: String, escapeAction: EscapeAddActions) {
        let params:[String:Any] = ["escape_id":escapeId, "escape_action":escapeAction.rawValue]
        
        ServiceCall(.patch, serviceType: .ServiceTypePrivateApi, subServiceType: .UpdateEscape, params: params, delegate: self)
    }
    
    func getActionForEscape(escapeId: String) {
        let params:[String:Any] = ["escape_id":escapeId]
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetEscapeAction, params: params, delegate: self)
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
    
    func verifyItunesReceipt(receiptData: String) {
        
        let params:[String:String] = ["receipt_data":receiptData]
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .verifyReceipt, params: params, delegate: self)
    }
    
    func getItemDesc(_ escapeType : EscapeType?, id : String){
        var params : [String:Any] = [:]
        params["escape_id"] = id
        if let escapeType = escapeType {
            params["escape_type"] = escapeType.rawValue
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetItemDesc, params: params, delegate: self)
    }
    
    func logoutUser() {
        ECUserDefaults.setLoggedIn(false)
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
            case .verifyReceipt:
                if let verificationResponse = service.outPutResponse as? [String: Any] {
                    parseItunesVerificationReceipt(verificationResponse)
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
            case .PutProfilePicture:
                MyAccountDataProvider.sharedDataProvider.getUserDetails(nil)
                break
            case .GetSimilarEscape:
                if let data = service.outPutResponse as? [[String:Any]], let params = service.parameters {
                    self.parseSimilarEscapeData(data: data, page: params["page"] as? Int)
                }
                break
                
            case .GetRelatedPeople:
                if let data = service.outPutResponse as? [[String:Any]], let params = service.parameters {
                    self.parseRelatedPeopleData(data: data, page: params["page"] as? Int)
                }
                break
                
            case .GetEscapeAction:
                if let data = service.outPutResponse as? [String:Any] {
                    if let action = data["action"] as? String, let escapeId = data["escape_id"] as? String {
                        if let delegate = escapeActionDelegate, let escapeAction = EscapeAddActions(rawValue: action) {
                            delegate.receivedActionForEscape(escapeId: escapeId, escapeAction: escapeAction)
                        }
                    }
                }
                break
            case .GetUserEscapes:
                if let data = service.outPutResponse as? [[String:Any]] {
                    
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
                ScreenVader.sharedVader.loginAction()
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
                    
                }
                break
                
            case .GetFollowers:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    
                }
                break
                
            case .GetFriends:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    
                }
                break
            case .PostRecommend:
                Logger.debug("recommendation posted 200 OK")
                break
                
            case .GetLinkedObjects:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    
                }
                break
                
            case .GetSharedUsersOfStory:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    
                }
                break
                
            case .UpdateFirstName:
                fallthrough
            case .UpdateLastName:
                fallthrough
            case .UpdateEmail:
                fallthrough
            case .UpdatePassword:
                NotificationCenter.default.post(name: NSNotification.Name(NotificationObservers.UserDetailsDataObserver.rawValue), object: nil)
                fallthrough
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
                
            case .GetSimilarEscape:
                if let delegate = self.similarEscapesDelegate {
                    delegate.failedToReceivedData()
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
    
    func parseItunesVerificationReceipt(_ data:[String:Any]) {
        guard let success = data["success"] as? Bool, let userProfileData = data["user_profile_data"] as? [String:Any] else {
            return
        }
        var userWasGuest: Bool = false
        if let user = self.currentUser {
            userWasGuest = (user.userTypeEnum() == .Guest)
        }
        
        parseUserDetails(userProfileData, userId: nil)
        
        if success {
            
            IAPVader.sharedVader.succesfullyVerified(shouldDismiss: !userWasGuest)
        } else {
            if let message = data["message"] as? String {
                
                IAPVader.sharedVader.failedWithMessage(message: message)
            }
        }
    }
    
    func updateProfileListWith(_ data: [String: AnyObject]) {
        guard let listTypeStr = data["list_type"] as? String,
            let listType = ProfileListType(rawValue: listTypeStr),
            let userId = data["user_id"] as? String,
            let listData = data["list_data"] as? [[String:AnyObject]] else {
                return
        }
        
        
        if let currentUser = currentUser, let currentUserId = currentUser.id, currentUserId == userId, listType != .Activity {
            
            RealmDataVader.sharedVader.writeOrUpdateProfileList(userId, type: listTypeStr, listData: listData)
        } else {
            
            let profileList = ProfileList()
            profileList.type = listTypeStr
            profileList.userId = userId
            profileList.parseDataNoRealm(listData)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.OtherUserProfileListFetchObserver.rawValue), object: nil, userInfo: ["type":listTypeStr, "data":profileList])
        }
        
    }
    
    func parseUserDetails(_ dict: [String:Any], userId: String?) {
        Logger.debug("User Details :\(dict)")
        
        let userData: MyAccountItems = MyAccountItems(dict: dict, userType: nil)
        
        if userId == nil {  // save in case of self only.
            saveUserDataToRealm(userData)
            
            if self.myAccountDetailsDelegate != nil {
                self.myAccountDetailsDelegate!.recievedUserDetails()
            }
            
            if let userPreferences = dict["user_preferences"] as? [Any] {
                UserPreferenceVader.shared.setPreferencesWith(data: userPreferences)
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.UserDetailsDataObserver.rawValue), object: nil, userInfo: nil)
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.GetProfileDetailsObserver.rawValue), object: nil, userInfo: ["userData": userData])
        }
        
    }
    
    
    func parseRelatedPeopleData(data: [[String:Any]], page: Int?) {
        var dataArray:[MyAccountItems] = []
        
        for eachItem in data {
            guard let _ = eachItem["first_name"] as? String,
                let _ = eachItem["id"] as? String else {
                    continue
            }
            
            dataArray.append(MyAccountItems(dict: eachItem, userType: nil))
        }
        
        
        if let delegate = self.relatedPeopleDelegate {
            delegate.receivedRelatedPeople(dataArray, page: page)
        }
    }
    
    
    func parseSimilarEscapeData(data: [[String:Any]], page: Int?) {
        var dataArray:[EscapeItem] = []
        
        for eachItem in data {
            guard let itemTitle = eachItem["name"] as? String,
                let itemId = eachItem["id"] as? String,
                let escapeType = eachItem["escape_type"] as? String else {
                    continue
            }
            
            dataArray.append(EscapeItem.addOrEditEscapeItem(itemId, name: itemTitle, escapeType: escapeType, posterImage: eachItem["poster_image"] as? String, year: eachItem["year"] as? String, rating: eachItem["rating"] as? NSNumber, subTitle: eachItem["subtitle"] as? String, createdBy: eachItem["creator"] as? String, _realm: nil, nextAirtime: eachItem["next_airtime"] as? [String:Any]))
        }
        
        
        if let delegate = self.similarEscapesDelegate {
            delegate.receivedSimilarEscapes(dataArray, page: page)
        }
    }
    
    func parseEscapeListData(_ data: [[String:Any]], escape_type: String, escapeAction: String?, userId: String?, page: Int?) {
        var dataArray:[EscapeItem] = []
        
        for eachItem in data {
            guard let itemTitle = eachItem["name"] as? String,
                let itemId = eachItem["id"] as? String,
                let escapeType = eachItem["escape_type"] as? String else {
                    continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(itemId, name: itemTitle, escapeType: escapeType, posterImage: eachItem["poster_image"] as? String, year: eachItem["year"] as? String, rating: eachItem["rating"] as? NSNumber, subTitle: eachItem["subtitle"] as? String, createdBy: eachItem["creator"] as? String, _realm: nil, nextAirtime: eachItem["next_airtime"] as? [String:Any])
            if let hasActed = eachItem["is_acted"] as? Bool {
                escapeItem.hasActed = hasActed
            }
            
            dataArray.append(escapeItem)
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
    
    func parseDescData(_ dict: [String:AnyObject], id: String) {
        
        var dataItems: DescDataItems = DescDataItems(dict: dict)
        
        if self.itemDescDelegate != nil{
            self.itemDescDelegate?.receivedItemDesc(dataItems, id : id)
        }
        
    }
    
    
    func getRelatedPeople(escapeId: String, page: Int?) {
        
        var params : [String:Any] = [:]
        params["escape_id"] = escapeId
        
        if let page = page {
            params["page"] = page
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetRelatedPeople, params: params, delegate: self)
    }
    
    func getSimilarEscapes(escapeId: String, escapeType: EscapeType?, page: Int?) {
        
        var params : [String:Any] = [:]
        params["escape_id"] = escapeId
        
        if let escapeType = escapeType {
            params["escape_type"] = escapeType.rawValue
        }
        
        if let page = page {
            params["page"] = page
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetSimilarEscape, params: params, delegate: self)
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
            
            
            userData.followers = userItem.followers.intValue
            
            userData.following = userItem.following.intValue
            userData.track_count = userItem.trackingsCount.intValue
            
            if userData.alerts_count != userItem.alertsCount.intValue || userData.seen_count != userItem.seenCount.intValue || userData.escape_count != userItem.escapes_count.intValue {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationObservers.CountsDidUpdateObserver.rawValue), object: nil)
            }
            userData.alerts_count = userItem.alertsCount.intValue
            userData.seen_count = userItem.seenCount.intValue
            
            userData.escape_count = userItem.escapes_count.intValue
            
            if let oldUserData = self.currentUser {
                let oldUserType = oldUserData.userTypeEnum()
                
                if !oldUserData.isPremium() && userItem.isPremium() {
                    ScreenVader.sharedVader.makeToast(toastStr: "Upgraded to Premium Membership")
                } else if !userItem.isPremium() && oldUserData.isPremium() {
                    
                    
                    let alert = UIAlertController(title: "Premium Membership", message: "Your premium membership expired, please renew.", preferredStyle: .alert)
                    let renewAction = UIAlertAction(title: "Renew Now", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: { 
                            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openTVistPremiumView, queryParams: nil)
                        })
                        
                    })
                    
                    alert.addAction(renewAction)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
                        
                    })
                    
                    alert.addAction(cancelAction)
                    
                    ScreenVader.sharedVader.showAlert(alert: alert)
                }
                
                if oldUserType == .Guest && userItem.isPremium() {
                    ScreenVader.sharedVader.performUniversalScreenManagerAction(.openSignUpView, queryParams: ["no_dismiss": true])
                }
            }
            userData.userType = userItem.userType
            
            
        
            RealmDataVader.sharedVader.writeToRealm(userData, background: false)
            self.currentUser = userData
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
                            uiRealm.add(escapeData, update: true)
                            self.currentUser?.escapeList.append(escapeData)
                        })
                        
                    }
                }
            }
        }
    }
    
}





