//
//  MediaDataProvider.swift
//  Mizzle
//
//  Created by Rahul Meena on 05/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

protocol MediaViewingOptionsProtocol:class {
    func mediaViewingOptions(viewingOptions:[StreamingOption])
}

protocol MediaAirtimesDataProtocol:class {
    func didReceiveAirtimes(airtimes: [Airtime])
}

class MediaDataProvider: CommonDataProvider {
    
    static let shared = MediaDataProvider()
    
    weak var mediaViewingOptionsDelegate:MediaViewingOptionsProtocol?
    weak var mediaAirtimesDelegate:MediaAirtimesDataProtocol?
    
    func fetchViewingOptions(viewingOptionType: ViewingOptionType, escapeId: String) {
        let params: [String: Any] = ["escape_id": escapeId, "type": viewingOptionType.rawValue]
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetViewingOptions, params: params, delegate: self)
    }
    
    
    func fetchAirtimes(escapeId: String, page: Int?) {
        
        var params: [String: Any] = ["escape_id": escapeId]
        
        if let page = page {
            params["page"] = page
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetAirtimes, params: params, delegate: self)
        
    }
    
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .GetViewingOptions:
                parseViewingOptions(viewingOptions: service.outPutResponse as? [AnyObject])
                break
            case .GetAirtimes:
                if let airtimes = service.outPutResponse as? [Any] {
                    parseAllAirtimes(airtimes)
                }
                break
            default: break
            }
        }
    }
    
    override func serviceError(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .GetViewingOptions:
                
                break
            default: break
            }
        }
    }
    
    
    // MARK: - Parsers
    
    func parseAllAirtimes(_ data: [Any]) {
        
        var airtimes: [Airtime] = []
        
        for eachItem in data {
            if let eachItem = eachItem as? [String:Any] {
                if let airtime = Airtime.createAirtime(eachItem) {
                   airtimes.append(airtime)
                }
            }
        }
        
        if let mediaAirtimesDelegate = mediaAirtimesDelegate {
            mediaAirtimesDelegate.didReceiveAirtimes(airtimes: airtimes)
        }
    }
    
    func parseViewingOptions(viewingOptions: [AnyObject]?) {
        guard let viewingOptions = viewingOptions else {
            return
        }
        
        var viewingOptionsArr:[StreamingOption] = []
        
        for eachItem in viewingOptions {
            if let eachItemData = eachItem as? [String:Any] {
                if let streamingOption = StreamingOption.parseStreamingOptionData(data: eachItemData) {
                    viewingOptionsArr.append(streamingOption)
                }
            }
        }
        
        if let mediaViewingOptionsDelegate = self.mediaViewingOptionsDelegate {
            mediaViewingOptionsDelegate.mediaViewingOptions(viewingOptions: viewingOptionsArr)
        }
    }
}
