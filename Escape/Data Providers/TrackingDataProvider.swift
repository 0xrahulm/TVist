//
//  TrackingDataProvider.swift
//  Mizzle
//
//  Created by Rahul Meena on 19/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit


let kTrackingDataNotification = "kTrackingDataNotification"


class TrackingDataProvider: CommonDataProvider {
    
    static let shared = TrackingDataProvider()
    
    func fetchTrackingData(page: Int) {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .UserTrackings, params: ["page": page], delegate: self)
    }
    
    func addTrackingFor(escapeId: String) {
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UserTrackings, params: ["escape_id":escapeId], delegate: self)
    }
    
    func removeTrackingFor(escapeId: String) {
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .RemoveUserTracking, params: ["escape_id":escapeId], delegate: self)
    }
    
    var dopamineShotShown:Bool = false
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .UserTrackings:
                if service.method == .get {
                    
                    if let data = service.outPutResponse as? [AnyObject] {
                        var currentPage:Int = 1
                        if let params = service.parameters, let page = params["page"] as? Int {
                            currentPage = page
                        }
                        parseUserTrackings(data: data, page: currentPage)
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
                    Logger.debug("Could not fetch tracking data")
                } else {
                    
                    Logger.debug("Could not set Tracking for Media")
                }
                break;
            default:
                Logger.debug("Could not remove Tracking for Media")
                break;
            }
        }
    }
    
    
    // MARK: - 
    
    func parseUserTrackings(data: [AnyObject], page: Int) {
        
        var dataArray:[EscapeItem] = []
        
        for eachItem in data {
            
            guard let itemTitle = eachItem["name"] as? String,
                let itemId = eachItem["id"] as? String,
                let escapeType = eachItem["escape_type"] as? String else {
                    continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(itemId, name: itemTitle, escapeType: escapeType, posterImage: eachItem["poster_image"] as? String, year: eachItem["year"] as? String, rating: eachItem["rating"] as? NSNumber, subTitle: eachItem["subtitle"] as? String, createdBy: eachItem["creator"] as? String, _realm: nil)
            if let hasActed = eachItem["is_acted"] as? Bool {
                escapeItem.hasActed = hasActed
            }
            
            if let isTracking = eachItem["is_tracking"] as? Bool {
                escapeItem.isTracking = isTracking
            }
            
            dataArray.append(escapeItem)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kTrackingDataNotification), object: nil, userInfo: ["trackings": dataArray, "page": page])
    }
}
