//
//  NetworkWrapper.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire

protocol NetworkWrapperProtocol : class {
    func serviceFinishedSucessfully(service : Service)
    func serivceFinishedWithError(service : Service)
}

class NetworkWrapper: NSObject {
    
    var headers : [String:String] = [:]
    var activeRequest : [Request] = []
    
    func serverCall(service : Service){
        
        print("server call with API url :: \(service.finalURL)")
        print("parameters \(service.parameters)")
        
        if (isNetworkAvailable()){
            
                setHeaders()
            
            let currentRequest = Alamofire.request(service.method, service.finalURL, parameters: service.parameters ,headers: headers)
            
            
                //checkForRequests(currentRequest)
            
                //activeRequest.append(currentRequest)
            
                currentRequest.responseJSON { response in
                            
                        self.recievedServerResponse(service, response: response)
                    
                }
            
        }else{
            if service.responderDelegate != nil{
                service.failedCount += 1
            }
            
        }
    }
    func checkForRequests(currentRequest : Request){
        if let url = currentRequest.task.originalRequest?.URLString{
            if url.containsString(SubServiceType.GetSearchItems.rawValue){
                for request in activeRequest{
                    if let url  = request.task.originalRequest?.URLString{
                        if url.containsString(SubServiceType.GetSearchItems.rawValue){
                            request.cancel()
                        }
                    }
                   
                }
            }
        }
    }
    
    func recievedServerResponse(service : Service , response :Response<AnyObject, NSError>){
        print("response from : \(response.response)")
        
        switch response.result {
        case .Success:
            
            service.failedCount = 0
            
            if service.responderDelegate != nil{
                
                if response.response?.statusCode >= 400 {
                    service.errorMessage = response.result.value
                    service.errorCode = response.response?.statusCode
                    service.responderDelegate!.serivceFinishedWithError(service)
                    
                }else{
                    service.outPutResponse = response.result.value
                    service.responderDelegate!.serviceFinishedSucessfully(service)
                }
            }
            
            break;
            
        case .Failure:
            service.errorMessage = response.result.value
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
        
        
        if let auth = DeviceID.getXauth(){
            headers["X-ESCAPE-AUTH-TOKEN"] = auth
            
            print ("TOKEN : \(auth)")
        }
        headers["X-DEVICE-ID"] = DeviceID.getDeviceID()
        headers["X-DEVICE-TYPE"] = UIDevice.currentDevice().modelName
        headers["X-OS-TYPE"] = "iOS"
        headers["Accept"] = "application/version.v1"
        
        print("Device id :\(DeviceID.getDeviceID())")
        
    }
    
}
