//
//  STBDeviceSearchViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 01/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
//import CocoaAsyncSocket

enum CellIdentifierForDeviceSearch: String {
    case STBSingleTableViewCell = "STBSingleTableViewCell"
}

class STBDeviceSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    let mSearchData = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST: urn:schemas-upnp-org:device:MediaRenderer:1\r\n\r\n".data(using: String.Encoding.utf8) //all devices
    var ssdpAddres          = "239.255.255.250"
    var ssdpPort:UInt16     = 1900
//    var ssdpSocket:GCDAsyncUdpSocket!
//    var ssdpSocketRec:GCDAsyncUdpSocket!
    var error : NSError?

    var registerableCells:[CellIdentifierForDeviceSearch] = [.STBSingleTableViewCell]

    var allDevices: [STBDevice] = []
    var serialNumbersPresent: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Device"
        
        //send M-Search
//        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
//        if let mSearchData = mSearchData {
//
//            ssdpSocket.send(mSearchData, withTimeout: 1, tag: 0)
//            //bind for responses
//            do {
//                try ssdpSocket.enableReusePort(true)
//                try ssdpSocket.bind(toPort: ssdpPort)
//                try ssdpSocket.joinMulticastGroup(ssdpAddres)
//            } catch {
//                TvRemoteDataProvider.shared.postRemoteLogs(logs: "Error Trying to enable SSDP Port")
//            }
//
//        }
        
        initXibs()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(STBDeviceSearchViewController.receivedData(notification:)), name: Notification.Name(rawValue:NotificationObservers.RemoteDeviceParsedDataObserver.rawValue), object: nil)
        
        searchForDevices()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["items"] as? [STBDevice] {
                self.appendToArray(newData: itemsData)
                self.tableView.reloadData()
            }
        }
        
        self.emptyView.isHidden = self.allDevices.count > 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func socketStop() {
//        ssdpSocket.pauseReceiving()
        
        if self.allDevices.count == 0 {
            AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceSearchNoDeviceFound)
            self.activityLabel.text = "Could not find any DirecTV Device"
            self.loadingView.stopAnimating()
            self.retryButton.isHidden = false
        }
    }
    
    @IBAction func didTapOnRetryButton(sender: UIButton) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceSearchRetryButtonClick)
        searchForDevices()
    }
    
    func initXibs() {
        for genericCell in registerableCells {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
    func searchForDevices() {
        self.loadingView.startAnimating()
        self.perform(#selector(STBDeviceSearchViewController.socketStop), with: nil, afterDelay: 2*60)
//        do {
//            try ssdpSocket.beginReceiving()
//        } catch {
//
//        }
        self.retryButton.isHidden = true
    }
    
//    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
//
//        if let printableData = String(data: data, encoding: String.Encoding.utf8) {
//            print("Did Receive data \r\n++++++==================================----------------------")
//
//            if printableData.lowercased().contains("media") {
//                AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceSearchDirecTVDeviceFound)
//                TvRemoteDataProvider.shared.postRemoteLogs(logs: printableData)
//
//                let splitString = printableData.components(separatedBy: "\r\n")
//                var locationStr:String = ""
//                for eachLine in splitString {
//                    if eachLine.contains("Location:") {
//                        locationStr = eachLine
//                    }
//                }
//
//                let location = locationStr.replacingOccurrences(of: "Location:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
//
//                if location != "" {
//                    DirecTVader.sharedVader.getXMLData(location: location)
//                }
//            }
//
//        }
//    }
    
    func appendToArray(newData: [STBDevice]) {
        for eachElem in newData {
            if !serialNumbersPresent.contains(eachElem.serialNumber) {
                serialNumbersPresent.append(eachElem.serialNumber)
                self.allDevices.append(eachElem)
                
                
                if self.allDevices.count > 0 {
                    let lastItem = self.allDevices[self.allDevices.count-1]
                    var params: [String: String] = ["total_devices_shown": "\(self.allDevices.count)"]
                    
                    if let direcTVHMC = lastItem.directvHMC, direcTVHMC.characters.count > 0 {
                        params["DirecTVHMC"] = direcTVHMC
                    }
                    
                    if let friendlyName = lastItem.friendlyName {
                        params["DeviceName"] = friendlyName
                    }
                    
                    if let host = lastItem.host {
                        params["HostIp"] = host
                    }
                    AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceSearchDirecTVDeviceShown, properties: params)
                }
            }
        }
    }
    
//    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
//        print("didConnectToAddress")
//        print("\(address)")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension STBDeviceSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.allDevices[indexPath.row]
        
        DirecTVader.sharedVader.defaultSelectedDevice(device: item)
        
        self.navigationController?.popViewController(animated: true)
        
        
        var params: [String: String] = ["total_devices_shown": "\(self.allDevices.count)"]
        
        if let direcTVHMC = item.directvHMC, direcTVHMC.characters.count > 0 {
            params["DirecTVHMC"] = direcTVHMC
        }
        
        if let friendlyName = item.friendlyName {
            params["DeviceName"] = friendlyName
        }
        
        if let host = item.host {
            params["HostIp"] = host
        }
        
        AnalyticsVader.sharedVader.basicEvents(eventName: .DeviceSearchDirecTVDeviceSelected, properties: params)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = self.allDevices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierForDeviceSearch.STBSingleTableViewCell.rawValue, for: indexPath) as! STBSingleTableViewCell
        cell.stbDevice = element
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}


