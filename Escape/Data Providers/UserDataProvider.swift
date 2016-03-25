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

class UserDataProvider: CommonDataProvider {
    
    static let sharedDataProvider  = UserDataProvider()
    
    var securityToken : String?
    
    
    func getSecurityToken(){
        
       //ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUsers, params: nil, delegate: self)
      
    }
    func postFBtoken(token : String , expires_in : NSTimeInterval){
    
        
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .FBSignIn, params: ["facebook_token" : token , "expires_in" : expires_in], delegate: self)
        
    }
    
    override func serviceSuccessfull(service: Service) {
        
        switch service.subServiveType {
        case .testSubService :
            print("Response \(service.outPutResponse)")

            break
            
        case .FBSignIn:
            print("FB response success")
            if let data = service.outPutResponse as? [String:AnyObject]{
                self.parseFBUserData(data)
            }
            break
            
        default:
            break
        }
    
    }
    override func serviceError(service: Service) {
        switch service.subServiveType {
        case .FBSignIn:
            print("FB post error : \(service.errorCode)")
            break
            
        default :
            print("Service error code \(service.errorCode)")
            break
        }
    }
    

}
extension UserDataProvider{
    func parseFBUserData(dict : [String : AnyObject]){
        ECUserDefaults.setLoggedIn(true)
        
    }
}

    


