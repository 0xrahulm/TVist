//
//  DiscoverDataProvider.swift
//  Escape
//
//  Created by Ankit on 01/06/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import Alamofire

class DiscoverDataProvider: CommonDataProvider {
    
    static let shareDataProvider = DiscoverDataProvider()
    
    var searchServices : [Service] = []
    
    func getDiscoverItems(discovertype : DiscoverType, page : Int){
        
        var params : [String:AnyObject] = [:]
        
        
        params["discovery_type"] =  discovertype.rawValue // discovery type required
        params["page"] = page
        
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetDiscoverItems, params: params, delegate: self)
    }
    
    func getSearchItems(queryText : String, searchType : SearchType, limit : Int?, page : Int?){
        
        var params : [String:AnyObject] = [:]
        
        
        params["type"] =  searchType.rawValue // discovery type required
        params["query"] = queryText
        if let page = page{
          params["page"] = page
        }
        if let limit = limit{
            params["limit"] = limit
        }
        
        for service in activeServices{
            if service.subServiveType == .GetSearchItems{
               
            }
        }

        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetSearchItems, params: params, delegate: self)
        
        
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
                
            case .GetSearchItems:
                if let data = service.outPutResponse as? [AnyObject]{
                    if let params = service.parameters{
                        if let searchType = params["type"] as? String,
                           let queryText = params["query"] as? String{
                            self.parseSearchedData(data, searchType: searchType, queryText: queryText, page: params["page"] as? Int)
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
                
            case .GetSearchItems:
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
    func parseSearchedData(data : [AnyObject], searchType : String, queryText : String, page : Int?){
        var searchedItems : SearchItems?
        var tempPage = 0
        if let page = page{
            tempPage = page
        }
        searchedItems = SearchItems(dict: data)
        
        if let data = searchedItems?.searchData{
            print("searched data count \(data.count)")
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationObservers.SearchObserver.rawValue, object: ["data" : data, "type" : searchType, "queryText" : queryText, "page" : tempPage])
        }
        
    }
}

