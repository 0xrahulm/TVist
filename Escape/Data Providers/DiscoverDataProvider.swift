//
//  DiscoverDataProvider.swift
//  Escape
//
//  Created by Ankit on 01/06/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol DiscoverDataProtocol : class {
    func recievedDiscoverData(data : [DiscoverItems]?, discoverType : DiscoverType)
    func errorDiscoverData()
}

class DiscoverDataProvider: CommonDataProvider {
    
    var discoverAll : [DiscoverItems] = []
    var discoverMovie : [DiscoverItems] = []
    var discoverTvshows : [DiscoverItems] = []
    var discoverBooks : [DiscoverItems] = []
    var discoverPeople : [DiscoverItems] = []
    
    static let shareDataProvider = DiscoverDataProvider()
    
    weak var discoverDataDelegate : DiscoverDataProtocol?
    
    func getDiscoverItems(discovertype : DiscoverType, page : Int){
        
        var params : [String:AnyObject] = [:]
        
        
        params["discovery_type"] =  discovertype.rawValue // discovery type required
        params["page"] = page
        
        
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
        
        var discoverItem : DiscoverItems?
        
        discoverItem = DiscoverItems(dict: data)
        
        if DiscoverType(rawValue: discoverType) == .Books{
            if let data = discoverItem?.discoverData{
                for item in data{
                    discoverBooks.append(item)
                }
            }
        }else if DiscoverType(rawValue: discoverType) == .All{
            if let data = discoverItem?.discoverData{
                for item in data{
                    discoverAll.append(item)
                }
            }
        }else if DiscoverType(rawValue: discoverType) == .Movie{
            if let data = discoverItem?.discoverData{
                for item in data{
                    discoverMovie.append(item)
                }
            }
        }else if DiscoverType(rawValue: discoverType) == .TvShows{
            if let data = discoverItem?.discoverData{
                for item in data{
                    discoverTvshows.append(item)
                }
            }
        }else if DiscoverType(rawValue: discoverType) == .People{
            if let data = discoverItem?.discoverData{
                for item in data{
                    discoverPeople.append(item)
                }
            }
        }
       
        if discoverDataDelegate != nil {
            discoverDataDelegate?.recievedDiscoverData(discoverItem?.discoverData, discoverType: DiscoverType(rawValue: discoverType)!)
        }
    }
    
    func getStoredDiscoverData(discoverType : DiscoverType) -> [DiscoverItems]?{
        if discoverType == .Books{
            return discoverBooks
        }else if discoverType == .All{
            return discoverAll
        }else if discoverType == .Movie{
            return discoverMovie
        }else if discoverType == .TvShows{
            return discoverTvshows
        }
        return nil
        
    }
}

