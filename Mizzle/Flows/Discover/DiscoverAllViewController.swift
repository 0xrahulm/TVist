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
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        dataArray = []
        tableView.reloadData()
        loadingView.startAnimating()
        
//        tableView.register(UINib(nibName: CellIdentifier.FBFriends.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.FBFriends.rawValue)
        
       NotificationCenter.default.addObserver(self, selector: #selector(DiscoverAllViewController.receivedNotification(_:)), name: NSNotification.Name(rawValue: NotificationObservers.DiscoverObserver.rawValue), object: nil)
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        callFurther = false
    }
    
    @objc func receivedNotification(_ notification : Notification){
        loadingView.stopAnimating()
        if let dict = notification.object as? [String:AnyObject]{
            if let type = dict["type"] as? String, let discoverType = DiscoverType(rawValue: type) {
                if self.type == discoverType{
                    if let data = dict["data"] as? [DiscoverItems]{
                        self.dataArray.append(contentsOf: data)
                        if data.count == 0{
                            callFurther = false
                        }else{
                            callFurther = true
                        }
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension DiscoverAllViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataArray[indexPath.row].discoverType == .People{
            return 70
        }
        if dataArray[indexPath.row].discoverType == .Story {
            return 200
        }
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if dataArray.count > 0{
            
            let data = dataArray[indexPath.row]
            let id = data.id
            
            let escapeType = data.discoverType
            let name = data.name
            let image = data.image
            
            var params : [String:Any] = [:]
            if let id = id{
                params["id"] = id
            }
            if let escapeType = escapeType{
                params["escape_type"] = escapeType.rawValue
            }
            if let name = name{
                params["name"] = name
            }
            if let image = image{
                params["image"] = image
            }
            
            if let id = id,let name = name,let escapeType = escapeType {
//                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.TopCharts_Item_Click, properties: ["escape_name": name, "escape_id":id, "escape_type": escapeType.rawValue])
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

extension DiscoverAllViewController: RemoveFbCardProtocol {
    func removeFBCard(_ indexPath: IndexPath) {
        
        if dataArray.count > indexPath.row{
            dataArray.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .right)
    }
}

extension DiscoverAllViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= dataArray.count - 5{
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let data = dataArray[indexPath.row]
        
        if let discoveryType = data.discoverType {
            if discoveryType == .Story {
                    
            }
        }
        
        var cell : DiscoverEscapeTableViewCell!
        if indexPath.row == dataArray.count - 1 && callFurther{
            cell = tableView.dequeueReusableCell(withIdentifier: "loadingViewCellIdentifier") as! DiscoverEscapeTableViewCell
            cell.loadingView.startAnimating()
            
        }else if data.discoverType != .People{
            
            var discoverCellIdentifier = "discoverEscapeCellIdentifier"
            
            if type == .All {
                discoverCellIdentifier = "discoverEscapeWithTagCellIdentifier"
            }
            cell = tableView.dequeueReusableCell(withIdentifier: discoverCellIdentifier) as! DiscoverEscapeTableViewCell
            cell.data = data
            cell.indexPath = indexPath
            cell.removeAddedEscapeCellDelegate = self
        }else if data.discoverType == .People{
            cell = tableView.dequeueReusableCell(withIdentifier: "followCellIdentifier") as! DiscoverEscapeTableViewCell
            cell.peopleData = data
            cell.followButtonDiscoverDelegate = self
            cell.indexPath = indexPath

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}

extension DiscoverAllViewController : RemoveAddedEscapeCellProtocol{
    func removeAtIndex(_ indexPath : IndexPath){
        if dataArray.count > indexPath.row{
            dataArray.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .right)
        
        if dataArray.count == 0{
            callFurther = true
            currentPage = 0
            loadMoreData()
        }
        
    }
}

extension DiscoverAllViewController : FollowerButtonProtocol{
    func changeLocalDataArray(_ indexPath: IndexPath?, isFollow: Bool) {
        if let indexPath = indexPath{
            if dataArray.count > indexPath.row{
                dataArray[indexPath.row].isFollow = isFollow
            }
        }
    }
}
