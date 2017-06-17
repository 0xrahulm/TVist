//
//  TvGuideDataProvider.swift
//  Mizzle
//
//  Created by Rahul Meena on 13/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

let kTvGuideDataNotification:String = "kTvGuideDataNotification"

class TvGuideDataProvider: CommonDataProvider {
    
    static let shared = TvGuideDataProvider()
    
    
    func fetchGuideList(listType: GuideListType) {
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetGuideList, params: ["list_type":listType.rawValue], delegate: self)
    }
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .GetGuideList:
                parseGuideListData(guideData: service.outPutResponse as? [String:AnyObject])
                break
            default: break
            }
        }
    }
    
    override func serviceError(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .GetGuideList:
                
                break
            default: break
            }
        }
    }
    
    //MARK:- Parsers
    
    func parseGuideListData(guideData: [String:AnyObject]?) {
        
        guard let guideData = guideData else {
            return
        }
        
        
        guard let listTypeStr = guideData["list_type"] as? String,
            let listType = GuideListType(rawValue: listTypeStr),
            let userId = guideData["user_id"] as? String,
            let listData = guideData["list_data"] as? [[String:AnyObject]] else {
                return
        }
        
        
        let guideList = GuideList()
        guideList.type = listType
        guideList.userId = userId
        guideList.parseData(listData)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.TvGuideDataObserver.rawValue), object: nil, userInfo: ["type":listTypeStr, "data":guideList])
        
        
    }
    
}
