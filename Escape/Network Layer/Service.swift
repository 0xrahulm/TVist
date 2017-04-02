//
//  Service.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire

class Service: NSObject {
    
    var serviceType : ServiceType?
    var subServiveType : SubServiceType?
    
    var parameters : [String:Any]?
    var method : HTTPMethod = .get
    
    var outPutResponse : Any?
    var errorMessage : Any?
    var errorCode : Int!
    var failedCount = 0
    var finalURL : String!
    var responderDelegate: NetworkWrapperProtocol?
    
    init(method : HTTPMethod, serviceType : ServiceType, subServiveType : SubServiceType, parameters : [String:Any]?) {
        
        self.serviceType = serviceType
        self.subServiveType = subServiveType
        self.parameters = parameters
        self.method = method
        
        super.init()
        
        constructFinalUrl()
        
        
    }
    fileprivate func constructFinalUrl(){
        
        switch subServiveType{
        
        default:
            if let serviceType = serviceType{
                if let subServiveType = subServiveType{
                    self.finalURL = "\(serviceType.rawValue)\(subServiveType.rawValue)"
                }
            }
        }
    }
    

}
