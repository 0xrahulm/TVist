//
//  SearchAllViewController.swift
//  Escape
//
//  Created by Ankit on 17/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol DismissKeyboardProtocol : class {
    func dismissKeyBoard()
}

class SearchAllViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var dismissKeyboardDelegate : DismissKeyboardProtocol?
    
    var type : SearchType = .All
    var dataArray : [SearchItems] = []
    var searchedText  = ""
    var currentPage = 1
    var callFurther = true
    var callOnce = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        dataArray = []
        tableView.reloadData()
        
        initObservers()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("didappear : \(type)")
        
        if let text = ECUserDefaults.getSearchedText(){
            self.searchedText = text
        }
        if callOnce{
            searchQuery()
            callOnce = false
        }
        
        
    }
    
    func initObservers(){
        
        // for receiving searched data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchAllViewController.receivedNotification(_:)), name:NotificationObservers.SearchObserver.rawValue, object: nil)
        
        // for receiving searched text
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchAllViewController.recievedSearchedText(_:)), name:NotificationObservers.SearchQueryObserver.rawValue, object: nil)
        
    }
    
    deinit{
        ECUserDefaults.removeSearchedText()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationObservers.SearchObserver.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationObservers.SearchQueryObserver.rawValue, object: nil)
    }
    
    func searchQuery(){
        
        if let queryText = ECUserDefaults.getSearchedText(){
            if queryText.characters.count < 3{
                
                dataArray = []
                tableView.reloadDataAnimated()
                
            }else{
                if currentPage == 1{
                    dataArray = []
                    dataArray.append(SearchItems(searchType: .Blank))
                    tableView.reloadDataAnimated()
                    
                    _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(SearchAllViewController.validateSearch(_:)), userInfo: queryText, repeats: false)
                    
                }else{
                    searchCall(queryText)
                }
            }
        }
    }
    func searchCall(text : String){
        DiscoverDataProvider.shareDataProvider.getSearchItems(text, searchType: type, limit: 10, page: currentPage)
    }
    
    func recievedSearchedText(notification : NSNotification){
        if let dict = notification.object as? [String:AnyObject]{
            if let text = dict["searchText"] as? String{
                self.searchedText = text
                currentPage = 1
                callFurther = true
                searchQuery()
            }
        }
    }
    
    func receivedNotification(notification : NSNotification){
        if self.dataArray.count == 1 && dataArray[0].searchType == .Blank{
            self.dataArray = []
        }
        
        if let dict = notification.object as? [String:AnyObject]{
            if let type = dict["type"] as? String,
                let searchType = SearchType(rawValue: type),
                let queryText = dict["queryText"] as? String{
                if let searchedText = ECUserDefaults.getSearchedText(){
                    if self.type == searchType && queryText == searchedText{
                        if let data = dict["data"] as? [SearchItems]{
                            
                            self.dataArray.appendContentsOf(data)
                            if data.count < 10{
                                callFurther = false
                            }
                            if let page = dict["page"] as? Int{
                                if page > 1{
                                    tableView.reloadData()
                                }else{
                                    tableView.reloadDataAnimated()
                                }
                            }else{
                              tableView.reloadDataAnimated()    
                            }
                            
                        }
                    }
                    
                }
                
            }
        }
    }
    func loadMoreData(){
        if callFurther{
            currentPage = currentPage + 1
            searchQuery()
        }
    }
    
    func validateSearch(timer : NSTimer){
        
        if let text = timer.userInfo as? String{
            if let searchedText = ECUserDefaults.getSearchedText(){
                if text == searchedText{
                    
                    searchCall(text)
                }
            }
        }
        
    }
}
extension SearchAllViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if dataArray[indexPath.row].searchType == .User || dataArray[indexPath.row].searchType == .Blank{
            return 70
        }
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if dataArray.count > 0{
            
            let data = dataArray[indexPath.row]
            let id = data.id
            
            let escapeType = data.searchType
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
            if escapeType == .Movie || escapeType == .TvShows || escapeType == .Books{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }else if escapeType == .User{
                if let id  = data.id{
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenUserAccount, queryParams: ["user_id":id, "isFollow" : data.isAddedOrFollow])
                }
            }
        }
    }
    
    
}
extension SearchAllViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 5 && indexPath.row >= dataArray.count - 2{
            loadMoreData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : SearchTableViewCell!
        
        if dataArray.count > indexPath.row{
            let data = dataArray[indexPath.row]
            
            if data.searchType == .Blank && callFurther{
                cell = tableView.dequeueReusableCellWithIdentifier("loadingViewCellIdentifier") as! SearchTableViewCell
                cell.loadingViewLabel.text = "searching for \(self.searchedText)"
                cell.loadingView.startAnimating()
                
            }else if data.searchType != .User{
                
                var discoverCellIdentifier = "searchEscapeCellIdentifier"
                
                if type == .All {
                    discoverCellIdentifier = "searchEscapeWithTagCellIdentifier"
                }
                cell = tableView.dequeueReusableCellWithIdentifier(discoverCellIdentifier) as! SearchTableViewCell
                cell.data = data
                cell.indexPath = indexPath
                
            }else if data.searchType == .User{
                cell = tableView.dequeueReusableCellWithIdentifier("followCellIdentifier") as! SearchTableViewCell
                cell.peopleData = data
                cell.followButtonDiscoverDelegate = self
                cell.indexPath = indexPath
                
            }
            
            
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("loadingViewCellIdentifier") as! SearchTableViewCell
            cell.loadingViewLabel.text = ""
            cell.loadingView.stopAnimating()
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension SearchAllViewController : FollowerButtonProtocol{
    func changeLocalDataArray(indexPath: NSIndexPath?, isFollow: Bool) {
        if let indexPath = indexPath{
            if dataArray.count > indexPath.row{
                dataArray[indexPath.row].isAddedOrFollow = isFollow
            }
        }
    }
}
extension SearchAllViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let delegate = dismissKeyboardDelegate{
            delegate.dismissKeyBoard()
        }
    }
}
