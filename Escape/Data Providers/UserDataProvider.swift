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

protocol EmailLoginProtocol : class{
    
    func signInSuccessfull(data : [String:AnyObject])
    func signInError(data : AnyObject?)
}

class UserDataProvider: CommonDataProvider {
    
    static let sharedDataProvider  = UserDataProvider()
    
    weak var emailLoginDelegate : EmailLoginProtocol?
    
    
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
    
    
// MARK: - Service Responses
    
    override func serviceSuccessfull(service: Service) {
        
        switch service.subServiveType {
        case .testSubService :

            break
            
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
            
        default:
            break
        }
    
    }
    override func serviceError(service: Service) {
        switch service.subServiveType {
        case .FBSignIn:
            break
            
        case .EmailSignUp:
            print("Email signup error: \(service.errorCode)")
            
            if self.emailLoginDelegate != nil {
                self.emailLoginDelegate?.signInError(service.errorMessage)
            }
            
            break
            
        case .EmailSigIn:
            print("Email sign in error \(service.errorMessage)")
            if self.emailLoginDelegate != nil {
                self.emailLoginDelegate?.signInError(service.errorMessage)
            }
            
            break
            
        default :
            print("Service error code \(service.errorCode)")
            break
        }
    }
    

}
// MARK: - Parsing

extension UserDataProvider{
    func parseFBUserData(dict : [String : AnyObject]){
        
        ECUserDefaults.setLoggedIn(true)
        ScreenVader.sharedVader.performScreenManagerAction(.MainTab, queryParams: nil)
        
        if let token = JSON(dict)["auth_token"].string{
            DeviceID.saveXauth(token)
            
            
        }
        
    }
    
    func parseEmailSignInUserData(dict : [String : AnyObject]){
        
        ECUserDefaults.setLoggedIn(true)
        if let token = JSON(dict)["auth_token"].string{
            DeviceID.saveXauth(token)
            
            if self.emailLoginDelegate != nil{
                self.emailLoginDelegate?.signInSuccessfull(dict)
            }
        }
    }
    
}

    


