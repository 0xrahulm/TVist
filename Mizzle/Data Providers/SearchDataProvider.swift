//
//  SearchDataProvider.swift
//  Mizzle
//
//  Created by Rahul Meena on 12/05/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import Alamofire

class SearchDataProvider: NSObject, NetworkWrapperProtocol {
    
    static let shared = SearchDataProvider()

    var activeServices : [Service] = []
    
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
        
        serviceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetSearchItemsNoAuth, params: params, delegate: self)
        
        
    }
    
    func serviceCall(_ method :HTTPMethod, serviceType : ServiceType, subServiceType : SubServiceType, params : [String:Any]? , delegate : NetworkWrapperProtocol){
        
        
        let service = Service(method : method ,serviceType: serviceType, subServiveType: subServiceType, parameters: params)
        
        activeServices.append(service)
        service.responderDelegate = delegate
        let wrapperObject = NetworkWrapper()
        
        wrapperObject.serverCall(service)
        
        NetworkAvailability.sharedNetwork.activeServices.append(service)
        
    }
    
    func serviceSuccessfull(_ service:Service){
        if let subServiceType = service.subServiveType{
            switch subServiceType {
            case .GetSearchItemsNoAuth:
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
    func serviceError(_ service : Service){
        
        //override this methodi in base class
    }
    
    
    
    func parseSearchedData(_ data : [AnyObject], searchType : String, queryText : String, page : Int?){
        var searchedItems : SearchItems?
        var tempPage = 0
        if let page = page{
            tempPage = page
        }
        searchedItems = SearchItems(dict: data)
        
        if let data = searchedItems?.searchData{
            print("searched data count \(data.count)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.SearchObserver.rawValue), object: ["data" : data, "type" : searchType, "queryText" : queryText, "page" : tempPage])
        }
        
    }
    
    func cancelAllRequest(){
        activeServices = []
        NetworkAvailability.sharedNetwork.activeServices = []
    }
    
    
    func serivceFinishedWithError(_ service: Service) {
        if service.errorCode != nil{
            if service.errorCode == 401 {  // logout
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
