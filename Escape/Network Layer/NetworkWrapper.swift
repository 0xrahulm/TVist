//
//  NetworkWrapper.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol NetworkWrapperProtocol : class{
    func serviceFinishedSucessfully(service : Service)
    func serivceFinishedWithError(service : Service)
}

class NetworkWrapper: NSObject {
    
    var headers : [String:String] = [:]
    
    
    func serverCall(service : Service){
        
        print("server call with API url :: \(service.finalURL)")
        
        if (isNetworkAvailable()){
            
                setHeaders()
                
                Alamofire.request(service.method, service.finalURL, parameters: service.parameters ,headers: headers).responseJSON { response in
                            
                        self.recievedServerResponse(service, response: response)
                    
                }
            
            
        }else{
            if service.responderDelegate != nil{
                service.failedCount++
            }
            
        }
    }
    
    func recievedServerResponse(service : Service , response :Response<AnyObject, NSError>){
        print("response from : \(response.response)")
        
        switch response.result {
        case .Success:
            service.outPutResponse = response.result.value
            service.failedCount = 0
            if service.responderDelegate != nil{
                service.responderDelegate!.serviceFinishedSucessfully(service)
            }
            
            break;
            
        case .Failure:
            service.errorMessage = response.result.error
            service.errorCode = response.response?.statusCode
            if service.responderDelegate != nil{
                service.responderDelegate!.serivceFinishedWithError(service)
            }
            break;
        }
        
    }
    
    func isNetworkAvailable() -> Bool{
        
        let status  = NetworkAvailability.sharedNetwork.isNetworkAvailble
        
        return status
        
        
    }
    func setHeaders(){
        
        let id = DeviceID()
        
        if let auth = id.getXauth(){
            headers["X-ESCAPE-AUTH"] = auth
        }
        
        headers["X-DEVICE-ID"] = id.getDeviceID()
        headers["X-DEVICE-TYPE"] = UIDevice.currentDevice().modelName
        headers["X-OS-TYPE"] = "iOS"
        headers["Accept"] = "application/version.v1"
        
        print("Device id :\(id.getDeviceID())")
        
    }
    
}





    
    




// request
//response
//threading
//network avaliblity in seperate singleton