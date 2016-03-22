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
        
        
        Alamofire.request(.GET, "http://api.androidhive.info/contacts/", parameters: nil)
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    if let data = response.result.value {
                        if let arr = JSON(data)["contacts"].array{
                            for data in arr{
                                let name = data["name"].stringValue
                                print("name : \(name)")
                            }
                        }
                    }
                    break;
                    
                case .Failure:
                    print("failed \(response.result.error)")
                    break;
                }
                
        }
        
    }
    
//    func ServiceCall(method :Alamofire.Method , subServiceType : NetworkConstants.SubServiceType , parameters : [String:AnyObject]){
//        
//        
//    }
//    func ServiceSuccessResponse(subServiceType : NetworkConstants.SubServiceType) -> Alamofire.responseJSON{
//        
//    }
    
    

}
