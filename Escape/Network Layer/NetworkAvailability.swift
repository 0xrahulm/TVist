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
    case WWAN
    case WiFi
    
    var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}

class NetworkAvailability: NSObject {
    
    static let sharedNetwork = NetworkAvailability()
    var isNetworkAvailble = true
    
    var activeServices : [Service] = []
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NetworkAvailability.networkStatusChanged(_:)), name: ReachabilityStatusChangedNotification, object: nil)
        monitorReachabilityChanges()
        
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        print(userInfo)
        if ((userInfo?.description.containsString("Online"))) == true{
            
            isNetworkAvailble = true
            
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
            self.performSelector(#selector(NetworkAvailability.callPendingServices), withObject: nil, afterDelay: 2)
            
        } else {
            isNetworkAvailble = false
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
            self.performSelector(#selector(NetworkAvailability.openNetworkNotAvailablePopUp), withObject: nil, afterDelay: 2)
        }
    }
    
    func openNetworkNotAvailablePopUp(){
        
    }
    
    func callPendingServices(){
        for pendingService in activeServices {
            if pendingService.failedCount > 0 {
                let wrapperObject = NetworkWrapper()
                wrapperObject.serverCall(pendingService)
                
            }
        }
        
    }
    
    func removeServiceFromList(service: Service) {
        
        if let activeServiceIndex = self.activeServices.indexOf(service) where activeServiceIndex > -1 {
            self.activeServices.removeAtIndex(activeServiceIndex)
        }
    }
    
    
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return .Unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .Unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    
    func monitorReachabilityChanges() {
        let host = "google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            
            NSNotificationCenter.defaultCenter().postNotificationName(ReachabilityStatusChangedNotification,
                object: nil,
                userInfo: ["Status": status.description])
            
            }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes)
    }
    
}
extension ReachabilityStatus {
    private init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.ConnectionRequired)
        let isReachable = flags.contains(.Reachable)
        let isWWAN = flags.contains(.IsWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .Online(.WWAN)
            } else {
                self = .Online(.WiFi)
            }
        } else {
            self =  .Offline
        }
    }
}
