//
//  STBDevice.swift
//  Mizzle
//
//  Created by Rahul Meena on 01/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class STBDevice: NSObject {
    
    var id: String?
    var friendlyName: String!
    var serialNumber: String!
    var udn: String?
    var directvHMC: String?
    var host: String!
    var port: String!
    
    
    class func parseSTBDeviceData(_ data: [String:Any]) -> STBDevice? {
        guard let name = data["name"] as? String, let serialNumber = data["serialNumber"] as? String, let host = data["host"] as? String, let port = data["port"] as? String else { return nil }
        
        let stbDevice = STBDevice()
        
        stbDevice.id = data["id"] as? String
        stbDevice.friendlyName = name
        stbDevice.directvHMC = data["directv_hmc"] as? String
        stbDevice.udn = data["UDN"] as? String
        stbDevice.host = host
        stbDevice.serialNumber = serialNumber
        stbDevice.port = port
        
        return stbDevice
    }
    
    func connectableString() -> String? {
        if let host = self.host, let port = self.port {
            
            return "http://\(host):\(port)/"
        }
        return nil 
    }
}


func ==(left:STBDevice, right:STBDevice) -> Bool {
    return left.serialNumber == right.serialNumber
}
