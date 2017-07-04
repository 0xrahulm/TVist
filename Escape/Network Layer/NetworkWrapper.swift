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
    var sessionManager: SessionManager!
    
    func serverCall(_ service : Service){
        
        print("server call with API url :: \(service.finalURL)")
        print("parameters \(String(describing: service.parameters))")
        
        if (isNetworkAvailable()){
            var encoding:ParameterEncoding = JSONEncoding.default
            if service.method == .get {
                encoding = URLEncoding.default
            }
            
            if sessionManager == nil {
                
                
                let certs = ServerTrustPolicy.certificates()
                
                let trustPolicies:[String : ServerTrustPolicy] = [
                    "api.mizzleapp.com": .pinCertificates(
                        certificates: certs,
                        validateCertificateChain: true,
                        validateHost: true
                    )
                ]
                
                sessionManager = SessionManager(configuration: URLSessionConfiguration.default, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: trustPolicies))
            }
            
            
            
            let currentRequest = sessionManager.request(service.finalURL, method: service.method, parameters: service.parameters, encoding: encoding, headers: appHeaders())
            
            
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
        print("response from : \(service.finalURL) \(response.result)")
        
        
        switch response.result {
        case .success(_):
            
            service.failedCount = 0
            
            if service.responderDelegate != nil{
                
                if response.result.isSuccess {
                    
                    if let responseData = response.response {
                        if responseData.statusCode >= 200 || responseData.statusCode < 300 {
                            
                            service.outPutResponse = response.result.value
                            service.responderDelegate!.serviceFinishedSucessfully(service)
                        } else {
                            service.errorMessage = response.result.value
                            service.outPutResponse = response.result.value
                            service.errorCode = responseData.statusCode
                            
                            if service.responderDelegate != nil{
                                service.responderDelegate!.serivceFinishedWithError(service)
                            }
                        }
                    }
                }else{
                    printError(error: response.error)
                    service.errorMessage = response.result.value
                    service.errorCode = response.response?.statusCode
                    service.responderDelegate!.serivceFinishedWithError(service)
                }
                
            }
            
            break;
        case .failure(_):
            
            printError(error: response.error)
            service.errorMessage = response.result.value
            service.errorCode = response.response?.statusCode
            
            if service.responderDelegate != nil{
                service.responderDelegate!.serivceFinishedWithError(service)
            }
            break;
        }
        
    }
    
    func printError(error: Error?) {
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                print("Parameter encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                print("Multipart encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                print("Response validation failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                }
            case .responseSerializationFailed(let reason):
                print("Response serialization failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            }
            
            print("Underlying error: \(String(describing: error.underlyingError))")
        } else if let error = error as? URLError {
            print("URLError occurred: \(error)")
        } else {
            print("Unknown error: \(String(describing: error))")
        }
    }
    
    func isNetworkAvailable() -> Bool {
        
        let status  = NetworkAvailability.sharedNetwork.isNetworkAvailble
        
        return status
        
        
    }
    func appHeaders() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [:]
        if let auth = DeviceID.getXauth(){
            headers["X-ESCAPE-AUTH-TOKEN"] = auth
            
            print ("TOKEN : \(auth)")
        }
//        headers["X-DEVICE-ID"] = "043455A6-BE5B-09D0-BE41-3832CE2193ED"
        headers["X-DEVICE-ID"] = DeviceID.getDeviceID()
        
        headers["X-DEVICE-INFO"] = UIDevice.current.modelName
        headers["X-DEVICE-TYPE"] = "iOS"
        headers["Accept"] = "application/version.v1"
        headers["Accept"] = "application/json"
        
        print("Device id :\(DeviceID.getDeviceID())")
        return headers
    }
    
}
