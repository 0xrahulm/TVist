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
        
       NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DiscoverAllViewController.receivedNotification(_:)), name:NotificationObservers.DiscoverObserver.rawValue, object: nil)
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationObservers.DiscoverObserver.rawValue, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("didappear : \(type)")
      
        if callOnce{
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
    
    func receivedNotification(notification : NSNotification){
        if let dict = notification.object as? [String:AnyObject]{
            if let type = dict["type"] as? String, discoverType = DiscoverType(rawValue: type) {
                if self.type == discoverType{
                    if let data = dict["data"] as? [DiscoverItems]{
                        self.dataArray.appendContentsOf(data)
                        if data.count == 0{
                            callFurther = false
                        }
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension DiscoverAllViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if dataArray[indexPath.row].discoverType == .People{
            return 70
        }
        return 130
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
            }else if data.discoverType == .People{
                if let id  = data.id{
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenUserAccount, queryParams: ["user_id":id, "isFollow" : data.isFollow])
                }
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
            
            var discoverCellIdentifier = "discoverEscapeCellIdentifier"
            
            if type == .All {
                discoverCellIdentifier = "discoverEscapeWithTagCellIdentifier"
            }
            cell = tableView.dequeueReusableCellWithIdentifier(discoverCellIdentifier) as! DiscoverEscapeTableViewCell
            cell.data = data
            cell.indexPath = indexPath
            cell.removeAddedEscapeCellDelegate = self
        }else if data.discoverType == .People{
            cell = tableView.dequeueReusableCellWithIdentifier("followCellIdentifier") as! DiscoverEscapeTableViewCell
            cell.peopleData = data
            cell.followButtonDiscoverDelegate = self
            cell.indexPath = indexPath

        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
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

extension DiscoverAllViewController : FollowerButtonProtocol{
    func changeLocalDataArray(indexPath: NSIndexPath?, isFollow: Bool) {
        if let indexPath = indexPath{
            if dataArray.count > indexPath.row{
                dataArray[indexPath.row].isFollow = isFollow
            }
        }
    }
}
