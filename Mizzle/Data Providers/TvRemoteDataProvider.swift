//
//  TvRemoteDataProvider.swift
//  Mizzle
//
//  Created by Rahul Meena on 30/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
protocol RemoteDataProtocol:class {
    func didReceiveRemoteData(data: [ListingMediaItem], page: Int?)
    func didReceiveCategories(data: [ListingCategory])
    func errorRecievingRemoteData()
    func errorRecievingCategories()
}

class TvRemoteDataProvider: CommonDataProvider {

    static let shared = TvRemoteDataProvider()
    
    weak var remoteDataDelegate: RemoteDataProtocol?
    
    func getAiringNow(page: Int, categoryId: String?, channelNumber: String?, isLater: Bool = false) {
        
        var params:[String:Any] = ["page":page]
        
        if let categoryId = categoryId {
            params["category_id"] = categoryId
        }
        if let channelNumber = channelNumber {
            params["channel_number"] = channelNumber
        }
        
        if isLater {
            params["later"] = isLater
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .RemoteAiringNow, params: params, delegate: self)
    }
    
    func getCategories() {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .RemoteCategories, params: nil, delegate: self)
    }
    
    func postRemoteLogs(logs: String) {
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .RemoteLogs, params: ["data":logs], delegate: self)
    }
    
    func parseDeviceDataXml(receivedString: String, deviceIP: String) {
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .RemoteParseDevice, params: ["received_string":receivedString, "device_ip":deviceIP], delegate: self)
    }
    
    func saveDeviceData(device: STBDevice) {
        var params:[String:String] = ["serialNumber": device.serialNumber, "host": device.host, "name": device.friendlyName]
        if let direcTVHMC = device.directvHMC {
            params["directv_hmc"] = direcTVHMC
        }
        
        if let udn = device.udn {
            params["UDN"] = udn
        }
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .RemoteSaveDevice, params: ["data":params], delegate: self)
    }
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .RemoteAiringNow:
                if let response = service.outPutResponse as? [Any] {
                    parseRemoteData(remoteData: response, page: service.parameters?["page"] as? Int)
                } else {
                    errorFetchingRemoteData()
                }
                break
                
            case .RemoteCategories:
                if let response = service.outPutResponse as? [Any] {
                    parseRemoteCategory(categoryData: response)
                }
                break
            case .RemoteParseDevice:
                if let response = service.outPutResponse as? [Any] {
                    parseDevicesData(devicesData: response)
                }
            default: break
            }
        }
    }
    
    override func serviceError(_ service: Service) {
        
        if let subServiceType = service.subServiveType {
            switch subServiceType {
            case .RemoteAiringNow:
                errorFetchingRemoteData()
                break
            default: break
            }
        }
    }
    
    
    //MARK: - Parsers
    
    func parseDevicesData(devicesData: [Any]) {
        
        var stbDevices:[STBDevice] = []
        
        for eachItem in devicesData {
            if let eachItem = eachItem as? [String:Any] {
                if let stbDevice = STBDevice.parseSTBDeviceData(eachItem) {
                    stbDevices.append(stbDevice)
                }
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.RemoteDeviceParsedDataObserver.rawValue), object: nil, userInfo: ["items":stbDevices])
    }
    
    func parseRemoteData(remoteData: [Any], page: Int?) {
        
        var remoteItems:[ListingMediaItem] = []
        for eachItem in remoteData {
            if let eachData = eachItem as? [String:Any], let remoteItem = ListingMediaItem.parseListingMediaItem(eachData) {
                remoteItems.append(remoteItem)
            }
        }
        
        if let remoteDataDelegate = self.remoteDataDelegate {
            remoteDataDelegate.didReceiveRemoteData(data: remoteItems, page: page)
        }
    }
    
    func parseRemoteCategory(categoryData: [Any]) {
        var categoryItems:[ListingCategory] = []
        
        for eachItem in categoryData {
            if let eachData = eachItem as? [String: Any], let categoryItem = ListingCategory.createListingCategory(data: eachData) {
                categoryItems.append(categoryItem)
            }
        }
        
        if let remoteDataDelegate = self.remoteDataDelegate {
            remoteDataDelegate.didReceiveCategories(data: categoryItems)
        }
    }
    
    //MARK: - Error Fetching
    
    func errorFetchingRemoteData() {
        if let remoteDataDelegate = self.remoteDataDelegate {
            remoteDataDelegate.errorRecievingRemoteData()
        }
    }
    
    func errorFetchingCategory() {
        if let remoteDataDelegate = self.remoteDataDelegate {
            remoteDataDelegate.errorRecievingCategories()
        }
    }
}
