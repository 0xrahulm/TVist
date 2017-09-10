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
    

    func ServiceCall(_ method :HTTPMethod, serviceType : ServiceType, subServiceType : SubServiceType, params : [String:Any]? , delegate : NetworkWrapperProtocol){
        
        
        let service = Service(method : method ,serviceType: serviceType, subServiveType: subServiceType, parameters: params)
        
        activeServices.append(service)
        service.responderDelegate = delegate
        let wrapperObject = NetworkWrapper()
        
        wrapperObject.serverCall(service)
        
        NetworkAvailability.sharedNetwork.activeServices.append(service)
        
    }
    
    func serviceSuccessfull(_ service:Service){
     
        //override this method in base class
    }
    func serviceError(_ service : Service){
    
        //override this methodi in base class
    }
    func cancelAllRequest(){
        activeServices = []
        NetworkAvailability.sharedNetwork.activeServices = []
    }
    
    
    func serivceFinishedWithError(_ service: Service) {
        if service.errorCode != nil{
            if service.errorCode == 401 {  // logout
                
                ScreenVader.sharedVader.performLogout()
                cancelAllRequest()
            }else{
                if let activeServiceIndex = self.activeServices.index(of: service), activeServiceIndex > -1 {
                    self.serviceError(service)
                    self.activeServices.remove(at: activeServiceIndex)
                    NetworkAvailability.sharedNetwork.removeServiceFromList(service)
                }
                
            }
            
        }else{
            service.failedCount += 1  //because of network fail
        }
        
        
    }
    func serviceFinishedSucessfully(_ service: Service) {
        
        DispatchQueue.main.async{ [unowned self] in
            if let activeServiceIndex = self.activeServices.index(of: service), activeServiceIndex > -1 {
                self.serviceSuccessfull(service)
                self.activeServices.remove(at: activeServiceIndex)
                NetworkAvailability.sharedNetwork.removeServiceFromList(service)
            }
        }
    }
    
}
