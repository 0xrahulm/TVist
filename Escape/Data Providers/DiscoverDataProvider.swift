//
//  DiscoverDataProvider.swift
//  Escape
//
//  Created by Ankit on 01/06/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol DiscoverDataProtocol : class {
    func recievedDiscoverData(data : [DiscoverItems], discoverType : DiscoverType)
    func errorDiscoverData()
}

class DiscoverDataProvider: CommonDataProvider {
    
    static let shareDataProvider = DiscoverDataProvider()
    
    weak var discoverDataDelegate : DiscoverDataProtocol?
    
    func getDiscoverItems(discovertype : DiscoverType){
        
        var params : [String:AnyObject] = [:]
        
        
        params["discovery_type"] =  discovertype.rawValue // discovery type required
        
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetDiscoverItems, params: params, delegate: self)
    }
    
    override func serviceSuccessfull(service: Service) {
        switch service.subServiveType! {
            
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
    
    override func serviceError(service: Service) {
        switch service.subServiveType! {
        case .GetDiscoverItems:
            if discoverDataDelegate != nil{
                discoverDataDelegate?.errorDiscoverData()
            }
            break
            
        default:
            break
        }
    }
    
}
// MARK :- Parsing
extension DiscoverDataProvider{
    
    func parseDiscoverData(data : [AnyObject], discoverType : String ){
        
        var discoverData : [DiscoverItems] = []
        
        if let dataArray = data as? [[String:AnyObject]]{
            
            for dict in dataArray{
                
                discoverData.append(DiscoverItems(dict: dict))
                
            }
        }
        if discoverDataDelegate != nil{
            discoverDataDelegate?.recievedDiscoverData(discoverData, discoverType: DiscoverType(rawValue: discoverType)!)
        }
    }
}

