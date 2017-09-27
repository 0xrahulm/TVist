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
    
    func fetchWatchlistData(page: Int, type: FilterType, sortType: SortType, showAlertsOnly: Bool = false, isSeen: Bool = false) {
        var params: [String: Any] = ["page": page, "type":type.rawValue, "sort_type": sortType.rawValue, "alert": showAlertsOnly]
        if isSeen {
            params["escape_action"] = EscapeAddActions.Watched.rawValue
        }
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .UserWatchlist, params: params, delegate: self)
    }
    
    func addEditWatchlist(escapeId: String, shouldAlert: Bool) {
        let params: [String: Any] = ["escape_id": escapeId, "should_alert": shouldAlert]
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .AddToWatchlist, params: params, delegate: self)
    }
    
    func markEscapeSeen(escapeId: String) {
        let params: [String:Any] = ["escape_id":escapeId]
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .MarkItSeen, params: params, delegate: self)
    }
    
    func removeFromWatchlist(escapeId: String) {
        let params: [String:Any] = ["escape_id":escapeId]
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .RemoveFromWatchlist, params: params, delegate: self)
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
            case .AddToWatchlist:
                if let response = service.outPutResponse as? [String:Any], let status = response["status"] as? String {
                    Logger.debug("response \(status)")
                    if let alertsCount = response["alerts_count"] as? Int, let escapesCount = response["escapes_count"] as? Int {
                        
                        RealmDataVader.sharedVader.updateCountForCurrentUser(escapesCount: escapesCount, seenCount: nil, alertsCount: alertsCount)
                        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
                            
                            NotificationCenter.default.post(name: NSNotification.Name(NotificationObservers.CountsDidUpdateObserver.rawValue), object: nil)
                        }
                    }
                }
                break
            case .MarkItSeen:
                
                if let response = service.outPutResponse as? [String:Any], let status = response["status"] as? String {
                    Logger.debug("response \(status)")
                    if let alertsCount = response["alerts_count"] as? Int, let escapesCount = response["escapes_count"] as? Int, let seenCount = response["seen_count"] as? Int {
                        RealmDataVader.sharedVader.updateCountForCurrentUser(escapesCount: escapesCount, seenCount: seenCount, alertsCount: alertsCount)
    
                        NotificationCenter.default.post(name: NSNotification.Name(NotificationObservers.CountsDidUpdateObserver.rawValue), object: nil)
                        
                    }
                }
                break
            case .RemoveFromWatchlist:
                
                if let response = service.outPutResponse as? [String:Any], let status = response["status"] as? String {
                    Logger.debug("response \(status)")
                    if let alertsCount = response["alerts_count"] as? Int, let escapesCount = response["escapes_count"] as? Int, let seenCount = response["seen_count"] as? Int {
                        RealmDataVader.sharedVader.updateCountForCurrentUser(escapesCount: escapesCount, seenCount: seenCount, alertsCount: alertsCount)
                        NotificationCenter.default.post(name: NSNotification.Name(NotificationObservers.CountsDidUpdateObserver.rawValue), object: nil)
    
                    }
                }
                break
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
                escapeItem.isAlertSet = isTracking
            }
            
            dataArray.append(escapeItem)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kWatchlistDataNotification), object: nil, userInfo: ["watchlist": dataArray, "page": page, "type": type])
    }

}
