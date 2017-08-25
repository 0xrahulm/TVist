//
//  HomeDataProvider.swift
//  Escape
//
//  Created by Ankit on 04/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol HomeDataProtocol:class {
    func didReceiveHomeData()
}

class HomeDataProvider: CommonDataProvider {
    let shared = HomeDataProvider()
    
    func getHomeData(page: Int, type: FilterType) {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .HomeData, params: ["page":page, "type":type.rawValue], delegate: self)
    }
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .HomeData:
                if let response = service.outPutResponse as? [String:Any] {
                    parseHomeData(homeData: response)
                } else {
                    errorFetchingHome()
                }
                break
            default: break
            }
        }
    }
    
    override func serviceError(_ service: Service) {
        
        if let subServiceType = service.subServiveType {
            switch subServiceType {
            case .HomeData:
                errorFetchingHome()
                break
            default: break
            }
        }
    }
    
    
    //MARK: - Parsers
    
    func parseHomeData(homeData: [String:Any]) {
        
    }
    
    //MARK: - Error Fetching
    
    func errorFetchingHome() {
        
    }
}
