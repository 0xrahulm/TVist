//
//  UserDataProvider.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol LoginProtocol : class{
    
    func signInSuccessfull(data : [String:AnyObject] , type : LoginTypeEnum)
    func signInError(data : AnyObject?)
}

protocol InterestProtocol : class{
    func interestList(list : [InterestItems])
}

protocol NotificationProtocol : class {
    func recievedNotification(data : [NotificationItem])
    func error()
}

class UserDataProvider: CommonDataProvider {
    
    static let sharedDataProvider  = UserDataProvider()
    
    weak var emailLoginDelegate:   LoginProtocol?
    weak var fbLoginDelegate:      LoginProtocol?
    weak var interestDelegate:     InterestProtocol?
    weak var notificationDelegate : NotificationProtocol?
    
    func getSecurityToken(){
        
       //ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUsers, params: nil, delegate: self)
      
    }
    func postFBtoken(token : String , expires_in : NSTimeInterval){
    
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .FBSignIn, params: ["facebook_token" : token , "expires_in" : expires_in], delegate: self)
        
    }
    
    func registerUserWithEmail(name : String , email : String , password : String){
        
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .EmailSignUp, params: ["full_name":name , "email":email , "password":password], delegate: self)
    }
    
    func signInWithEmail(email : String, password : String){
        
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .EmailSigIn, params: ["email":email , "password":password], delegate: self)
        
    }
    
    func fetchInterest() {
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .FetchInterests, params: nil, delegate: self)
    }
    
    func postInterest(interests : [String]) {
        var params : [String:AnyObject] = [:]
        params["interests"] = interests
        
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .PostInterests, params: params, delegate: self)
    }
    
    func addToEscape(id : String, action : EscapeAddActions , status : String, friendsId : [String] , shareFB : UInt){
        var params : [String:AnyObject] = [:]
        params["escape_id"] = id
        params["escape_action"] = action.rawValue
        params["status"] = status
        
        params["tagged_users"] = friendsId
        
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .AddEscapes, params: params, delegate: self)
    }
    
    func followUser(id : String){
        var params : [String:AnyObject] = [:]
        params["user_id"] = id
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .FollowUser, params: params, delegate: self)
    }
    
    func unfollowUser(id : String){
        var params : [String:AnyObject] = [:]
        params["user_id"] = id
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .UnfollowUser, params: params, delegate: self)
    }
    
    func getNotification(){
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetNotification, params: nil, delegate: self)
    }
    
    
// MARK: - Service Responses
    
    override func serviceSuccessfull(service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
                
            case .FBSignIn:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    self.parseFBUserData(data)
                }
                break
                
            case .EmailSignUp:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    self.parseEmailSignInUserData(data)
                    
                }
                break
                
            case .EmailSigIn:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    self.parseEmailSignInUserData(data)
                }
                
                break
                
            case .FetchInterests:
                if let data = service.outPutResponse as? [AnyObject]{
                    self.parseIntereset(data)
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
    override func serviceError(service: Service) {
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
                print("Error in User UNfollow")
                break
                
            case .GetNotification:
                print("Error in getting notification")
                if let delegate = notificationDelegate{
                    delegate.error()
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
    func parseFBUserData(dict : [String : AnyObject]){
        
        ECUserDefaults.setLoggedIn(true)
        
        if let token = JSON(dict)["auth_token"].string{
            DeviceID.saveXauth(token)
            
            LocalStorageVader.sharedVader.setFlagForKey(.InterestsSelected)
            
            if self.fbLoginDelegate != nil{
                self.fbLoginDelegate?.signInSuccessfull(dict, type: .Facebook)
            }
            
            
        }
        
    }
    
    func parseEmailSignInUserData(dict : [String : AnyObject]){
        
        ECUserDefaults.setLoggedIn(true)
        
        if let token = JSON(dict)["auth_token"].string{
            DeviceID.saveXauth(token)
            if self.emailLoginDelegate != nil{
                self.emailLoginDelegate?.signInSuccessfull(dict , type: .Email)
            }
        }
    }
    
    func parseIntereset(data : [AnyObject]){
        
        var intersts : [InterestItems] = []
        
        if let data = data as? [[String:AnyObject]]{
            for item in data{
                if let id = item["id"] as? String {
                    if let name = item["name"] as? String{
                        if let weightage = item["weightage"] as? NSNumber{
                            if let isSelected = item["is_default_selected"] as? Bool{
                                
                                intersts.append(InterestItems(id: id, name: name, weightage: Int(weightage), isSelected: isSelected))
                            }
                            
                        }
                    }
                }
            }
        }
        if intersts.count > 0 {
            intersts = intersts.sort({ $0.weightage > $1.weightage })
        }
        
        if interestDelegate != nil{
            interestDelegate?.interestList(intersts)
        }
    }
    
    func parseNotification(data : [[String:AnyObject]]){
        let notificationData = NotificationItem(data : data).items
        
        if let delegate = notificationDelegate{
            delegate.recievedNotification(notificationData)
        }
    }
    
}

    


