//
//  UserDataProvider.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



protocol LoginProtocol : class{
    
    func signInSuccessfull(_ data : [String:AnyObject] , type : LoginTypeEnum, subServiceType: SubServiceType)
    func signInError(_ data : Any?)
}

protocol InterestProtocol : class{
    func interestList(_ list : [InterestItems])
}

protocol NotificationProtocol : class {
    func recievedNotification(_ data : [NotificationItem])
    func error()
}

protocol DeviceSessionProtocol: class {
    func guestUserLoggedIn(isFreshInstall: Bool)
    func userAlreadyExists(registeredUsers: [MyAccountItems])
}

protocol SupportTicketsProtocol: class {
    func didRecieveSupportTickets(items: [SupportTicketItem])
    func didCreateNewSupportTicket()
}

class UserDataProvider: CommonDataProvider {
    
    static let sharedDataProvider  = UserDataProvider()
    
    weak var emailLoginDelegate:   LoginProtocol?
    weak var fbLoginDelegate:      LoginProtocol?
    weak var interestDelegate:     InterestProtocol?
    weak var notificationDelegate : NotificationProtocol?
    weak var supportTicketsDelegate: SupportTicketsProtocol?
    weak var deviceSessionDelegate: DeviceSessionProtocol?
    
    var temporaryStoredUsers:[MyAccountItems] = []
    
    func getDeviceSession() {
        
       ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .DeviceSession, params: ["device_info": UIDevice.current.modelName], delegate: self)
    }
    func postFBtoken(_ token : String , expires_in : TimeInterval){
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .FBSignIn, params: ["facebook_token" : token , "expires_in" : expires_in, "device_info": UIDevice.current.modelName], delegate: self)
    }
    
    func registerUserWithEmail(_ name : String , email : String , password : String){
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .EmailSignUp, params: ["full_name":name , "email":email , "password":password, "device_info": UIDevice.current.modelName], delegate: self)
    }
    
    func signInWithEmail(_ email : String, password : String){
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .EmailSigIn, params: ["email":email , "password":password, "device_info": UIDevice.current.modelName], delegate: self)
        
    }
    
    func createNewSupportTicket(title:String, supportType: SupportTicketType, body: String) {
        let params: [String: Any] = ["title": title, "support_type": supportType.rawValue, "body": body]
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .CreateSupportTicket, params: params, delegate: self)
    }
    
    func getAllSupportTickets() {
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .UserSupportTickets, params: nil, delegate: self)
    }
    
    func fetchInterest() {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .FetchInterests, params: nil, delegate: self)
    }
    
    func postInterest(_ interests : [String]) {
        var params : [String:Any] = [:]
        params["interests"] = interests
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .PostInterests, params: params, delegate: self)
    }
    
    func addToEscape(_ id : String, action : EscapeAddActions , status : String, friendsId : [String] , shareFB : UInt){
        var params : [String:Any] = [:]
        params["escape_id"] = id
        params["escape_action"] = action.rawValue
        params["status"] = status
        
        params["tagged_users"] = friendsId
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .AddEscapes, params: params, delegate: self)
    }
    
    
    func updateDeviceTokenIfRequired(pushToken: String) {
        let storedPushToken = LocalStorageVader.sharedVader.valueForStoredKey(.PushToken) as? String ?? ""
        if storedPushToken != pushToken {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.NotificationPermissionProvided)
            ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UpdatePushToken, params: ["push_token":pushToken], delegate: self)
        }
    }
    
    func followUser(_ id : String){
        var params : [String:Any] = [:]
        params["user_id"] = id
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .FollowUser, params: params, delegate: self)
    }
    
    func unfollowUser(_ id : String){
        var params : [String:Any] = [:]
        params["user_id"] = id
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UnfollowUser, params: params, delegate: self)
    }
    
    func getNotification(){
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetNotification, params: nil, delegate: self)
    }
    
    func setPreferenceFor(key: UserPreferenceKey, value: Any) {
    
        UserPreferenceVader.shared.storeValueInKey(key, value: value)
        
        if let valueStr = UserPreferenceVader.shared.valueStringForPreference(preference: key) {
         
            AnalyticsVader.sharedVader.basicEvents(eventName: .UserAlertOptionsPreferenceChange, properties: ["preference_name": key.rawValue, "preference_value": valueStr])
        } else {
            
            AnalyticsVader.sharedVader.basicEvents(eventName: .UserAlertOptionsPreferenceChange, properties: ["preference_name": key.rawValue, "preference_value": "\(value)"])
        }
        var subServiceType: SubServiceType?
        switch key {
        case .alertPreference:
            subServiceType = .PostAlertPreference
            break
        case .onlyNewEpisodes:
            subServiceType = .PostNewEpisodesPreference
            break
            
        case .alertBeforeAirtime:
            subServiceType = .PostAlertBeforeAirtimePreference
            break
        case .timezonePreference:
            subServiceType = .PostTimeZonePreference
            break
        case .alertFrequency:
            subServiceType = .PostAlertFrequency
            break
        case .airdatePreference:
            subServiceType = .PostAirdatePreference
            break
        case .airtimePreference:
            subServiceType = .PostAirtimePreference
            break
        default:
            subServiceType = nil
        }
        if let subServiceType = subServiceType {
            
            ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: subServiceType, params: [key.rawValue: value], delegate: self)
        }
    }
    
    func premiumOnlyFeature(feature: FeatureIdentifier) -> Bool {
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            if user.isPremium() {
                return true
            }
            ScreenVader.sharedVader.performUniversalScreenManagerAction(UniversalScreenManagerAction.openPremiumPopupView, queryParams: ["feature":feature])
        }
        
        return false
    }
    
// MARK: - Service Responses
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .CreateSupportTicket:
                if let delegate = supportTicketsDelegate {
                    delegate.didCreateNewSupportTicket()
                }
                break
                
            case .FBSignIn:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    self.parseFBUserData(data)
                }
                break
                
            case .EmailSignUp:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    self.parseEmailSignInUserData(data, subServiceType: subServiceType)
                }
                break
            case .EmailSigIn:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    self.parseEmailSignInUserData(data, subServiceType: subServiceType)
                }
                break
                
            case .FetchInterests:
                if let data = service.outPutResponse as? [AnyObject]{
                    self.parseIntereset(data)
                }
                break
                
            case .UpdatePushToken:
                if let params = service.parameters, let pushToken = params["push_token"] as? String {
                    LocalStorageVader.sharedVader.storeValueInKey(.PushToken, value: pushToken)
                }
                break
            case .UserSupportTickets:
                if let supportTickets = service.outPutResponse as? [Any] {
                 
                    self.parseSupportTickets(data: supportTickets)
                }
                break
            case .AddEscapes:
                print("Escape Added")
                break
                
            case .FollowUser:
                print("User followed")
                break
                
            case .UnfollowUser:
                print("User UNfollowed")
                break
            case .PostAlertPreference:
                fallthrough
            case .PostNewEpisodesPreference:
                fallthrough
            case .PostAlertBeforeAirtimePreference:
                fallthrough
            case .PostAirtimePreference:
                fallthrough
            case .PostTimeZonePreference:
                fallthrough
            case .PostChannelsPreference:
                fallthrough
            case .PostAlertFrequency:
                fallthrough
            case .PostAirdatePreference:
                if let response = service.outPutResponse as? [String:Any], let status = response["status"] as? String {
                    print("Preference : \(status)")
                }
                break
                
            case .DeviceSession:
                if let data = service.outPutResponse as? [String:AnyObject] {
                    parseDeviceSessionData(data: data)
                }
                break
                
            case .GetNotification:
                if let data = service.outPutResponse as? [[String:AnyObject]]{
                    self.parseNotification(data)
                }else{
                    if let delegate = notificationDelegate{
                        delegate.error()
                    }
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
            
            case .FBSignIn:
                
                ECUserDefaults.setLoggedIn(false)
                
                if self.fbLoginDelegate != nil{
                    self.fbLoginDelegate?.signInError(service.errorMessage)
                }
                
                break
                
            case .EmailSignUp:
                
                ECUserDefaults.setLoggedIn(false)
                
                if self.emailLoginDelegate != nil {
                    self.emailLoginDelegate?.signInError(service.errorMessage)
                }
                
                break
                
            case .EmailSigIn:
                
                ECUserDefaults.setLoggedIn(false)
                
                if self.emailLoginDelegate != nil {
                    self.emailLoginDelegate?.signInError(service.errorMessage)
                }
                
                break
                
            case .AddEscapes:
                print("Error in Escape adding")
                break
                
            case .FollowUser:
                print("Error in User follow")
                break;
                
            case .UnfollowUser:
                print("Error in User Unfollow")
                break
                
            case .GetNotification:
                print("Error in getting notification")
                if let delegate = notificationDelegate{
                    delegate.error()
                }
                break
            case .PostAlertPreference:
                fallthrough
            case .PostNewEpisodesPreference:
                fallthrough
            case .PostAlertBeforeAirtimePreference:
                fallthrough
            case .PostAirtimePreference:
                fallthrough
            case .PostTimeZonePreference:
                fallthrough
            case .PostChannelsPreference:
                fallthrough
            case .PostAlertFrequency:
                fallthrough
            case .PostAirdatePreference:
                if let response = service.outPutResponse as? [String:Any], let status = response["error"] as? String {
                    print("Preference : \(status)")
                }
                break
                
            default :
                print("Service error code \(service.errorCode)")
                break
            }
        }
    }
    

}
// MARK: - Parsing

extension UserDataProvider{
    
    func parseSupportTickets(data: [Any]) {
        var supportTickets: [SupportTicketItem] = []
        
        for itemData in data {
            if let itemData = itemData as? [String:Any] {
             
                if let supportTicket = SupportTicketItem.parseSupportTicketData(itemData) {
                 
                    supportTickets.append(supportTicket)
                }
            }
        }
        
        if let delegate = self.supportTicketsDelegate {
            delegate.didRecieveSupportTickets(items: supportTickets)
        }
    }
    
    func parseDeviceSessionData(data: [String:AnyObject]) {
        
        if let token = data["auth_token"] as? String {
            ECUserDefaults.setLoggedIn(true)
            
            DeviceID.saveXauth(token)
            
            if let user = data["user"] as? [String:Any] {
                if let _ = user["id"] as? String {
                    let parsedUserData = MyAccountItems(dict: user, userType: nil)
                    MyAccountDataProvider.sharedDataProvider.saveUserDataToRealm(parsedUserData)
                }
            }
            var freshInstall = false
            if let freshInstallData = data["fresh_install"] as? Bool {
                freshInstall = freshInstallData
            }
            if let deviceSessionDelegate = self.deviceSessionDelegate {
                deviceSessionDelegate.guestUserLoggedIn(isFreshInstall: freshInstall)
            }
            
        } else {
            if let registeredUsers = data["registered_users"] as? [[String:AnyObject]] {
                var regUsers:[MyAccountItems] = []
                for eachUser in registeredUsers {
                    regUsers.append(MyAccountItems(dict: eachUser, userType: nil))
                }
                
                if let deviceSessionDelegate = self.deviceSessionDelegate {
                    self.temporaryStoredUsers = regUsers
                    deviceSessionDelegate.userAlreadyExists(registeredUsers: regUsers)
                }
                
            }
        }
    }
    
    func parseFBUserData(_ dict : [String : AnyObject]){
        
        
        if let token = dict["auth_token"] as? String {
            ECUserDefaults.setLoggedIn(true)
            
            DeviceID.saveXauth(token)
            
            if let user = dict["user"] as? [String:Any] {
                if let _ = user["id"] as? String {
                    let parsedUserData = MyAccountItems(dict: user, userType: nil)
                    MyAccountDataProvider.sharedDataProvider.saveUserDataToRealm(parsedUserData)
                }
            }
            
            LocalStorageVader.sharedVader.setFlagForKey(.InterestsSelected)
            
            if self.fbLoginDelegate != nil{
                self.fbLoginDelegate?.signInSuccessfull(dict, type: .Facebook, subServiceType: .FBSignIn)
            }
            
            
        }
        
        if let _ = dict["error"] as? String {
            
            if self.fbLoginDelegate != nil {
                self.fbLoginDelegate?.signInError(dict)
            }
        }
        
    }
    
    func parseEmailSignInUserData(_ dict : [String : AnyObject], subServiceType: SubServiceType){
        
        
        if let token = dict["auth_token"] as? String {
            ECUserDefaults.setLoggedIn(true)
            DeviceID.saveXauth(token)
            
            if let user = dict["user"] as? [String:Any] {
                if let _ = user["id"] as? String {
                    let parsedUserData = MyAccountItems(dict: user, userType: nil)
                    MyAccountDataProvider.sharedDataProvider.getUserDetails(nil)
                    MyAccountDataProvider.sharedDataProvider.saveUserDataToRealm(parsedUserData)
                }
            }
            
            if self.emailLoginDelegate != nil{
                self.emailLoginDelegate?.signInSuccessfull(dict , type: .Email, subServiceType: subServiceType)
            }
        }
        
        
        if let _ = dict["error"] as? String {
            
            if self.emailLoginDelegate != nil {
                self.emailLoginDelegate?.signInError(dict)
            }
        }
    }
    
    func parseIntereset(_ data : [AnyObject]){
        
        var intersts : [InterestItems] = []
        
        if let data = data as? [[String:AnyObject]]{
            for item in data{
                if let id = item["id"] as? String {
                    if let name = item["name"] as? String{
                            if let isSelected = item["is_default_selected"] as? Bool{
                                
                                intersts.append(InterestItems(id: id, name: name, weightage: nil, isSelected: isSelected))
                            }
                        
                    }
                }
            }
        }
        if intersts.count > 0 {
            intersts = intersts.sorted(by: { $0.weightage > $1.weightage })
        }
        
        if interestDelegate != nil{
            interestDelegate?.interestList(intersts)
        }
    }
    
    func parseNotification(_ data : [[String:AnyObject]]){
        let notificationData = NotificationItem(data : data).items
        
        if let delegate = notificationDelegate{
            delegate.recievedNotification(notificationData)
        }
    }
    
}

    


