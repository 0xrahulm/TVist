//
//  DiscoverAllViewController.swift
//  Escape
//
//  Created by Ankit on 29/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DiscoverAllViewController: UIViewController {
    
    var type : DiscoverType = .All
    var dataArray : [DiscoverItems] = []
    var callOnce = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        dataArray = []
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("didappear : \(type)")
        
        if callOnce{
            DiscoverDataProvider.shareDataProvider.discoverDataDelegate = self
            DiscoverDataProvider.shareDataProvider.getDiscoverItems(type)
            callOnce = false
        }
    }    
}

extension DiscoverAllViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if dataArray.count > 0{
            
            let data = dataArray[indexPath.row]
            let id = data.id
            
            let escapeType = data.discoverType
            let name = data.name
            let image = data.image
            
            var params : [String:AnyObject] = [:]
            if let id = id{
                params["id"] = id
            }
            if let escapeType = escapeType{
                params["escapeType"] = escapeType.rawValue
            }
            if let name = name{
                params["name"] = name
            }
            if let image = image{
                params["image"] = image
            }
            if data.discoverType == .Movie || data.discoverType == .TvShows || data.discoverType == .Books{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }
            
            
        }
        
    }
    
}
extension DiscoverAllViewController : UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discoverEscapeCellIdentifier") as! DiscoverEscapeTableViewCell
        let data = dataArray[indexPath.row]
        cell.data = data
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension DiscoverAllViewController : DiscoverDataProtocol{
    func recievedDiscoverData(data: [DiscoverItems]?, discoverType: DiscoverType) {
        if self.type == discoverType{
            if let data = data{
                self.dataArray = data
            }
            
            tableView.reloadData()
            
        }
        
    }
    func errorDiscoverData() {
        
    }
}
