//
//  DirecTVader.swift
//  Mizzle
//
//  Created by Rahul Meena on 01/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import Alamofire

enum DirecTVSignalType: String {
    case ChangeChannel = "tv/tune"
    case GetCurrentProgramming = "tv/getTuned"
    case GetLocations = "info/getLocations"
}

class DirecTVader: NSObject {
    static let sharedVader =  DirecTVader()
    
    var remoteConnectUri: String?
    
    override init() {
        super.init()
        
        if let storedUri = LocalStorageVader.sharedVader.valueForStoredKey(.RemoteConnectURI) as? String {
            remoteConnectUri = storedUri
        }
    }
    
    func defaultSelectedDevice(device: STBDevice) {
        
        if let connectableUri = device.connectableString() {
            
            TvRemoteDataProvider.shared.saveDeviceData(device: device)
            
            LocalStorageVader.sharedVader.storeValueInKey(.RemoteConnectURI, value: connectableUri)
            self.remoteConnectUri = connectableUri
            
            let deviceHMC = device.directvHMC ?? "DirecTV"
            
            ScreenVader.sharedVader.makeToast(toastStr: "Connected! Use remote now, for \(deviceHMC)")
            
            getLocations()
        }
    }
    
    func changeChannel(channelNumber: String) -> Bool {
        if let remoteConnectUri = self.remoteConnectUri {
            sendDirecTVRequest(stbUri: remoteConnectUri, type: .ChangeChannel, params: ["major": channelNumber])
            return true
        } else {
            return false
        }
    }
    
    func getTuned() -> Bool {
        
        if let remoteConnectUri = self.remoteConnectUri {
            sendDirecTVRequest(stbUri: remoteConnectUri, type: .GetCurrentProgramming, params: nil)
            return true
        } else {
            return false
        }
    }
    
    func getLocations() {
        if let remoteConnectUri = self.remoteConnectUri {
            sendDirecTVRequest(stbUri: remoteConnectUri, type: .GetLocations, params: nil)
        }
    }
    
    func sendDirecTVRequest(stbUri: String, type: DirecTVSignalType, params: [String: Any]?) {
        let finalUri = stbUri+type.rawValue
        if let url = URL(string: finalUri) {
            
            Alamofire.request(url, method: HTTPMethod.get, parameters: params, encoding: URLEncoding.default, headers: nil).responseString { response in
                
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    if let string = response.result.value {
                        TvRemoteDataProvider.shared.postRemoteLogs(logs: "Successfully Made \(type.rawValue) Request! status code is: \(String(describing: statusCode)) Result: \(string)")
                    }
                    break
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    TvRemoteDataProvider.shared.postRemoteLogs(logs: "Error Making \(type.rawValue) Request, status code is: \(String(describing: statusCode)): E-"+error.localizedDescription)
                    break
                }
            }
        }
    }
    
    func getXMLData(location: String) {
        if let url = URL(string: location) {
            Alamofire.request(url).responseString { response in
                
                var statusCode = response.response?.statusCode
                
                switch response.result {
                case .success:
                    print("status code is: \(String(describing: statusCode))")
                    if let string = response.result.value {
                        print("XML: \(string)")
                        TvRemoteDataProvider.shared.postRemoteLogs(logs: string)
                        if let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                            TvRemoteDataProvider.shared.parseDeviceDataXml(receivedString: encodedString, deviceIP: location)
                        }
                    }
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    TvRemoteDataProvider.shared.postRemoteLogs(logs: "Error Getting Location Data : E-"+error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    
}
