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

class MediaDataProvider: CommonDataProvider {
    
    static let shared = MediaDataProvider()
    
    weak var mediaViewingOptionsDelegate:MediaViewingOptionsProtocol?
    
    func fetchViewingOptions(viewingOptionType: ViewingOptionType, escapeId: String) {
        let params: [String: Any] = ["escape_id": escapeId, "type": viewingOptionType.rawValue]
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetViewingOptions, params: params, delegate: self)
    }
    
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .GetViewingOptions:
                parseViewingOptions(viewingOptions: service.outPutResponse as? [AnyObject])
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
