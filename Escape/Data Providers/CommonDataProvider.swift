//
//  CommonDataProvider.swift
//  Escape
//
//  Created by Ankit on 21/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire

class CommonDataProvider: NetworkWrapperProtocol {
    
    var activeServices : [Service] = []
    

    func ServiceCall(method :Alamofire.Method, serviceType : ServiceType, subServiceType : SubServiceType, params : [String:AnyObject]? , delegate : NetworkWrapperProtocol){
        
        
        let service = Service(method : method ,serviceType: serviceType, subServiveType: subServiceType, parameters: params)
        
        activeServices.append(service)
        service.responderDelegate = delegate
        let wrapperObject = NetworkWrapper()
        
        wrapperObject.serverCall(service)
        
        NetworkAvailability.sharedNetwork.activeServices.append(service)
        
    }
    
    func serviceSuccessfull(service:Service){
     
        //override this method in base class
    }
    func serviceError(service : Service){
    
        //override this methodi in base class
    }
    func cancelAllRequest(){
        activeServices = []
        NetworkAvailability.sharedNetwork.activeServices = []
    }
    
    
    func serivceFinishedWithError(service: Service) {
        if service.errorCode != nil{
            if service.errorCode == 401 {  // logout
                ScreenVader.sharedVader.performLogout()
                cancelAllRequest()
            }else{
                if let activeServiceIndex = self.activeServices.indexOf(service) where activeServiceIndex > -1 {
                    self.serviceError(service)
                    self.activeServices.removeAtIndex(activeServiceIndex)
                    NetworkAvailability.sharedNetwork.removeServiceFromList(service)
                }
                
            }
            
        }else{
            service.failedCount += 1  //because of network fail
        }
        
        
    }
    func serviceFinishedSucessfully(service: Service) {
        
        dispatch_async(dispatch_get_main_queue()){ [unowned self] in
            if let activeServiceIndex = self.activeServices.indexOf(service) where activeServiceIndex > -1 {
                self.serviceSuccessfull(service)
                self.activeServices.removeAtIndex(activeServiceIndex)
                NetworkAvailability.sharedNetwork.removeServiceFromList(service)
            }
        }
    }
    
}