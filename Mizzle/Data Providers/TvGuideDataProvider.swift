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
    
    
    func fetchGuideList(listType: FilterType) {
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetGuideList, params: ["list_type":listType.rawValue], delegate: self)
    }
    
    func fetchGuideItem(itemId: String, pageNo: Int?) {
        
        var params:[String:Any] = ["item_id": itemId]
        
        if let pageNo = pageNo {
            params["page"] = pageNo
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetGuideItem, params: params, delegate: self)
    }
    
    func fetchViewingOptions(viewingOptionType: ViewingOptionType, escapeId: String) {
        let params: [String: Any] = ["escape_id": escapeId, "type": viewingOptionType.rawValue]
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetViewingOptions, params: params, delegate: self)
    }
    
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .GetGuideList:
                parseGuideListData(guideData: service.outPutResponse as? [String:AnyObject])
                break
            case .GetGuideItem:
                if let params = service.parameters {
                    parseGuideItemData(guideItemData: service.outPutResponse as? [String:AnyObject], page: params["page"] as? Int)
                }
                break
            case .GetViewingOptions:
                
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
            let listType = FilterType(rawValue: listTypeStr),
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
    
    func parseGuideItemData(guideItemData: [String:AnyObject]?, page: Int?) {
        guard let guideItemData = guideItemData, let page = page else {
            return
        }
        
        if let guideItem = GuideItem.createGuideItem(itemData: guideItemData) {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.TvGuideItemDataObserver.rawValue), object: nil, userInfo: ["page":page, "item":guideItem])
        }
        
    }
    
}
