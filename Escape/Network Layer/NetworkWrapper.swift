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
    func serviceFinishedSucessfully(_ service : Service)
    func serivceFinishedWithError(_ service : Service)
}

class NetworkWrapper: NSObject {
    
    var activeRequest : [Request] = []
    
    func serverCall(_ service : Service){
        
        print("server call with API url :: \(service.finalURL)")
        print("parameters \(String(describing: service.parameters))")
        
        if (isNetworkAvailable()){
            
            
            let currentRequest = Alamofire.request(service.finalURL, method: service.method, parameters: service.parameters, encoding: JSONEncoding.default, headers: appHeaders())
            
            
            currentRequest.responseJSON(completionHandler: { (response) in
                
                self.recievedServerResponse(service, response: response)
            })
            
        }else{
            if service.responderDelegate != nil{
                service.failedCount += 1
            }
            
        }
    }
    func checkForRequests(_ currentRequest : Request){
        if let dataTask = currentRequest.task, let url = dataTask.originalRequest?.url?.absoluteString{
            
            if url.contains(SubServiceType.GetSearchItems.rawValue){
                for request in activeRequest{
                    if let task = request.task, let url  = task.originalRequest?.url?.absoluteString {
                        if url.contains(SubServiceType.GetSearchItems.rawValue){
                            request.cancel()
                        }
                    }
                   
                }
            }
        }
    }
    
    
    func recievedServerResponse(_ service : Service , response :DataResponse<Any>){
        print("response from : \(response.result)")
        
        switch response.result {
        case .success(_):
            
            service.failedCount = 0
            
            if service.responderDelegate != nil{
                if let responseCode = response.response {
                    
                    if responseCode.statusCode >= 400 {
                        service.errorMessage = response.result.value
                        service.errorCode = response.response?.statusCode
                        service.responderDelegate!.serivceFinishedWithError(service)
                        
                    }else{
                        service.outPutResponse = response.result.value
                        service.responderDelegate!.serviceFinishedSucessfully(service)
                    }
                }
            }
            
            break;
            
        case .failure(_):
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
    func appHeaders() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [:]
        if let auth = DeviceID.getXauth(){
            headers["X-ESCAPE-AUTH-TOKEN"] = auth
            
            print ("TOKEN : \(auth)")
        }
        headers["X-DEVICE-ID"] = DeviceID.getDeviceID()
        headers["X-DEVICE-TYPE"] = UIDevice.current.modelName
        headers["X-OS-TYPE"] = "iOS"
        headers["Accept"] = "application/version.v1"
        
        print("Device id :\(DeviceID.getDeviceID())")
        return headers
    }
    
}
