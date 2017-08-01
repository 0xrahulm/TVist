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
    
    func getDiscoverItems(_ discovertype : DiscoverType, page : Int){
        
        var params : [String:Any] = [:]
        
        
        params["discovery_type"] =  discovertype.rawValue // discovery type required
        params["page"] = page
        
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetDiscoverItems, params: params, delegate: self)
    }
    
    func getSearchItems(_ queryText : String, searchType : SearchType, limit : Int?, page : Int?){
        
        var params : [String:Any] = [:]
        
        
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

        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetSearchItems, params: params, delegate: self)
        
        
    }
    
    override func serviceSuccessfull(_ service: Service) {
        if let subServiceType = service.subServiveType{
            switch subServiceType {
                
            case .GetDiscoverItems:
                if let data = service.outPutResponse as? [AnyObject]{
                    if let params = service.parameters {
                        if let discoverType = params["discovery_type"] as? String {
                            self.parseDiscoverData(data, discoverType: discoverType)
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
    
    override func serviceError(_ service: Service) {
        if let subServiceType = service.subServiveType{
            
            switch subServiceType  {
            
            case .GetDiscoverItems:
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.DiscoverObserver.rawValue), object: ["error" : "error"])
                
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
    
    func parseDiscoverData(_ data : [AnyObject], discoverType : String ){
        
        var discoverItem : DiscoverItems?
        
        discoverItem = DiscoverItems(dict: data)
        
        if let data = discoverItem?.discoverData{
         
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.DiscoverObserver.rawValue), object: ["data" : data, "type":discoverType])
            
        }
    }
    
    func parseSearchedData(_ data : [AnyObject], searchType : String, queryText : String, page : Int?){
        var dataArray:[EscapeItem] = []
        
        for eachItem in data {
            
            guard let itemTitle = eachItem["name"] as? String,
                let itemId = eachItem["id"] as? String,
                let escapeType = eachItem["escape_type"] as? String else {
                    continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(itemId, name: itemTitle, escapeType: escapeType, posterImage: eachItem["poster_image"] as? String, year: eachItem["year"] as? String, rating: eachItem["rating"] as? NSNumber, subTitle: eachItem["subtitle"] as? String, createdBy: eachItem["creator"] as? String, _realm: nil, nextAirtime: eachItem["next_airtime"] as? [String:Any])
            if let hasActed = eachItem["is_acted"] as? Bool {
                escapeItem.hasActed = hasActed
            }
            
            if let isTracking = eachItem["is_tracking"] as? Bool {
                escapeItem.isTracking = isTracking
            }
            
            dataArray.append(escapeItem)
        }
        if let page = page {
            print("searched data count \(dataArray.count)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.SearchObserver.rawValue), object: ["data" : dataArray, "type" : searchType, "queryText" : queryText, "page" : page])
        }
        
        
    }
}

