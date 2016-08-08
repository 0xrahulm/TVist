//
//  DiscoverDataProvider.swift
//  Escape
//
//  Created by Ankit on 01/06/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DiscoverDataProvider: CommonDataProvider {
    
    static let shareDataProvider = DiscoverDataProvider()
    
    func getDiscoverItems(discovertype : DiscoverType, page : Int){
        
        var params : [String:AnyObject] = [:]
        
        
        params["discovery_type"] =  discovertype.rawValue // discovery type required
        params["page"] = page
        
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetDiscoverItems, params: params, delegate: self)
    }
    
    override func serviceSuccessfull(service: Service) {
        if let subServiceType = service.subServiveType{
            switch subServiceType {
                
            case .GetDiscoverItems:
                if let data = service.outPutResponse as? [AnyObject]{
                    if let params = service.parameters{
                        if let discoverType = params["discovery_type"] as? String{
                            self.parseDiscoverData(data, discoverType : discoverType)
                        }
                        
                    }
                    
                }
                break
                
            default:
                break
            }
            
        }
    }
    
    override func serviceError(service: Service) {
        if let subServiceType = service.subServiveType{
            
            switch subServiceType  {
            
            case .GetDiscoverItems:
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.DiscoverObserver.rawValue, object: ["error" : "error"])
                
                break
                
            default:
                break
            }
        }
    }
    
}
// MARK :- Parsing
extension DiscoverDataProvider{
    
    func parseDiscoverData(data : [AnyObject], discoverType : String ){
        
        var discoverItem : DiscoverItems?
        
        discoverItem = DiscoverItems(dict: data)
        
        if let data = discoverItem?.discoverData{
         
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.DiscoverObserver.rawValue, object: ["data" : data, "type":discoverType])
            
        }
    }
}

