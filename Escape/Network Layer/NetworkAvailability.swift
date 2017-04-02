//
//  NetworkAvailability.swift
//  Escape
//
//  Created by Ankit on 24/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import SystemConfiguration

let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

enum ReachabilityType: CustomStringConvertible {
    case wwan
    case wiFi
    
    var description: String {
        switch self {
        case .wwan: return "WWAN"
        case .wiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case offline
    case online(ReachabilityType)
    case unknown
    
    var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online (\(type))"
        case .unknown: return "Unknown"
        }
    }
}

class NetworkAvailability: NSObject {
    
    static let sharedNetwork = NetworkAvailability()
    var isNetworkAvailble = true
    
    var activeServices : [Service] = []
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NetworkAvailability.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        monitorReachabilityChanges()
        
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    func networkStatusChanged(_ notification: Notification) {
        let userInfo = notification.userInfo
        print(userInfo ?? "")
        if ((userInfo?.description.contains("Online"))) == true{
            
            isNetworkAvailble = true
            
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(NetworkAvailability.callPendingServices), with: nil, afterDelay: 2)
            
        } else {
            isNetworkAvailble = false
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(NetworkAvailability.openNetworkNotAvailablePopUp), with: nil, afterDelay: 2)
        }
    }
    
    func openNetworkNotAvailablePopUp(){
        ScreenVader.sharedVader.performScreenManagerAction(.NoNetworkPresent, queryParams: nil)
        
    }
    
    func callPendingServices(){
        ScreenVader.sharedVader.performScreenManagerAction(.NetworkPresent, queryParams: nil)
        
        for pendingService in activeServices {
            if pendingService.failedCount > 0 {
                let wrapperObject = NetworkWrapper()
                wrapperObject.serverCall(pendingService)
                
            }
        }
        
    }
    
    func removeServiceFromList(_ service: Service) {
        
        if let activeServiceIndex = self.activeServices.index(of: service), activeServiceIndex > -1 {
            self.activeServices.remove(at: activeServiceIndex)
        }
    }
    
    
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return .unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    
    func monitorReachabilityChanges() {
        let host = "google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityStatusChangedNotification),
                object: nil,
                userInfo: ["Status": status.description])
            
            }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
}
extension ReachabilityStatus {
    fileprivate init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wiFi)
            }
        } else {
            self =  .offline
        }
    }
}
