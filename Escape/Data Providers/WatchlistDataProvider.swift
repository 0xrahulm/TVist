//
//  WatchlistDataProvider.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

let kWatchlistDataNotification = "kWatchlistDataNotification"

class WatchlistDataProvider: CommonDataProvider {
    
    static let shared = WatchlistDataProvider()
    
    func fetchWatchlistData(page: Int, type: GuideListType) {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .UserWatchlist, params: ["page": page, "type":type.rawValue], delegate: self)
    }
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .UserWatchlist:
                if service.method == .get {
                    
                    if let data = service.outPutResponse as? [AnyObject] {
                        var currentPage:Int = 1
                        var typeS = "all"
                        if let params = service.parameters, let page = params["page"] as? Int, let type = params["type"] as? String {
                            currentPage = page
                            typeS = type
                        }
                        
                        parseWatchlist(data: data, page: currentPage, type: typeS)
                    }
                } else {
                    Logger.debug("Tracking set for Media")
                }
                break;
            default:
                Logger.debug("Tracking removed for Media")
                break;
            }
        }
    }
    
    
    override func serviceError(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .UserTrackings:
                
                if service.method == .get {
                    Logger.debug("Could not fetch watchlist data")
                } else {
                    
                    Logger.debug("Could not add Media to watchlist")
                }
                break;
            default:
                Logger.debug("Could not add Media to watchlist")
                break;
            }
        }
    }
    
    
    func parseWatchlist(data: [AnyObject], page: Int, type: String) {
        
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kWatchlistDataNotification), object: nil, userInfo: ["watchlist": dataArray, "page": page, "type": type])
    }

}
