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
    var currentPage = 1
    var callFurther = true
    
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
        
        if let preStoredData = DiscoverDataProvider.shareDataProvider.getStoredDiscoverData(type){
            dataArray = preStoredData
            tableView.reloadData()
            
        }
        
        if callOnce{
            DiscoverDataProvider.shareDataProvider.discoverDataDelegate = self
            DiscoverDataProvider.shareDataProvider.getDiscoverItems(type, page : currentPage)
            callOnce = false
        }
    }
    func loadMoreData(){
        if callFurther{
            currentPage = currentPage + 1
            DiscoverDataProvider.shareDataProvider.getDiscoverItems(type, page : currentPage)
        }
    }
}

extension DiscoverAllViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if dataArray[indexPath.row].discoverType == .People{
            return 55
        }
        return 120
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= dataArray.count - 5{
            loadMoreData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : DiscoverEscapeTableViewCell!
        
        let data = dataArray[indexPath.row]
        
        if indexPath.row == dataArray.count - 1 && callFurther{
            cell = tableView.dequeueReusableCellWithIdentifier("loadingViewCellIdentifier") as! DiscoverEscapeTableViewCell
            cell.loadingView.startAnimating()
            
        }else if data.discoverType != .People{
            cell = tableView.dequeueReusableCellWithIdentifier("discoverEscapeCellIdentifier") as! DiscoverEscapeTableViewCell
            cell.data = data
            cell.indexPath = indexPath
            cell.removeAddedEscapeCellDelegate = self
        }else if data.discoverType == .People{
            cell = tableView.dequeueReusableCellWithIdentifier("followCellIdentifier") as! DiscoverEscapeTableViewCell
            cell.peopleData = data
        }
        
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
                for item in data{
                   self.dataArray.append(item)
                }
                if data.count == 0{
                    callFurther = false
                }
                
            }
            tableView.reloadData()
        }
    }
    func errorDiscoverData() {
        
    }
}
extension DiscoverAllViewController : RemoveAddedEscapeCellProtocol{
    func removeAtIndex(indexPath : NSIndexPath){
        if dataArray.count > indexPath.row{
            dataArray.removeAtIndex(indexPath.row)
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        
        if dataArray.count == 0{
            callFurther = true
            currentPage = 0
            loadMoreData()
        }
        
    }
}
