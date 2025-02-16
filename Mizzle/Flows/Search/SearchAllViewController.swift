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
    var dataArray : [EscapeItem] = []
    var searchedText  = ""
    var currentPage = 1
    var callFurther = true
    var callOnce = true
    
    var searchPosition: String = "Guide"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        dataArray = []
        tableView.reloadData()
        
        initObservers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(SearchAllViewController.receivedNotification(_:)), name:NSNotification.Name(rawValue: NotificationObservers.SearchObserver.rawValue), object: nil)
        
        // for receiving searched text
        NotificationCenter.default.addObserver(self, selector: #selector(SearchAllViewController.recievedSearchedText(_:)), name:NSNotification.Name(rawValue: NotificationObservers.SearchQueryObserver.rawValue), object: nil)
        
    }
    
    deinit{
        ECUserDefaults.removeSearchedText()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationObservers.SearchObserver.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationObservers.SearchQueryObserver.rawValue), object: nil)
    }
    
    func searchQuery(){
        
        if let queryText = ECUserDefaults.getSearchedText(){
            if queryText.characters.count < 3 {
                
                dataArray = []
                tableView.reloadDataAnimated()
                
            } else {
                if currentPage == 1{
                    dataArray = []
                    
                    tableView.reloadDataAnimated()
                    
                    _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SearchAllViewController.validateSearch(_:)), userInfo: queryText, repeats: false)
                    
                } else {
                    searchCall(queryText)
                }
            }
        }
    }
    func searchCall(_ text : String){
        AnalyticsVader.sharedVader.searchOccurred(searchType: type.rawValue, searchTerm: text)
        DiscoverDataProvider.shareDataProvider.getSearchItems(text, searchType: type, limit: 10, page: currentPage)
    }
    
    @objc func recievedSearchedText(_ notification : Notification){
        if let dict = notification.object as? [String:AnyObject] {
            if let text = dict["searchText"] as? String{
                self.searchedText = text
                currentPage = 1
                callFurther = true
                searchQuery()
            }
        }
    }
    
    @objc func receivedNotification(_ notification : Notification){
        if self.dataArray.count == 1{
            self.dataArray = []
        }
        
        if let dict = notification.object as? [String:AnyObject]{
            if let type = dict["type"] as? String,
                let searchType = SearchType(rawValue: type),
                let queryText = dict["queryText"] as? String{
                if let searchedText = ECUserDefaults.getSearchedText(){
                    if self.type == searchType && queryText == searchedText{
                        if let data = dict["data"] as? [EscapeItem]{
                            if data.count == 0 {
                                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchInvalid, properties: ["Position":searchPosition])
                            } else {
                                if let page = dict["page"] as? Int {
                                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ItemsShown, properties: ["Position":searchPosition, "page":"\(page)"])
                                }
                            }
                            self.dataArray.append(contentsOf: data)
                            if data.count < 10{
                                callFurther = false
                            }else{
                                callFurther = true
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
        callFurther = false
    }
    
    @objc func validateSearch(_ timer : Timer){
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if dataArray.count > 0{
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchItemClick, properties: ["Position":searchPosition])
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.OpenedDescriptionSearchedItem, properties: ["Position":searchPosition])
            
            let data = dataArray[indexPath.row]
            
            let params:[String:AnyObject] = ["escapeItem":data]
            
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
            
        }
    }
    
    
}

extension SearchAllViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > 5 && indexPath.row >= dataArray.count - 2{
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : SearchTableViewCell!
        
        if dataArray.count > indexPath.row{
            let data = dataArray[indexPath.row]
            
                var discoverCellIdentifier = "searchEscapeCellIdentifier"
                
                if type == .All {
                    discoverCellIdentifier = "searchEscapeWithTagCellIdentifier"
                }
                cell = tableView.dequeueReusableCell(withIdentifier: discoverCellIdentifier) as! SearchTableViewCell
                cell.escapeItem = data
                cell.searchPosition = searchPosition
                cell.indexPath = indexPath
                
            
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "loadingViewCellIdentifier") as! SearchTableViewCell
            cell.loadingViewLabel.text = ""
            cell.loadingView.stopAnimating()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension SearchAllViewController : FollowerButtonProtocol{
    func changeLocalDataArray(_ indexPath: IndexPath?, isFollow: Bool) {
        if let indexPath = indexPath{
            if dataArray.count > indexPath.row{
                dataArray[indexPath.row].hasActed = isFollow
            }
        }
    }
}
extension SearchAllViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = dismissKeyboardDelegate{
            delegate.dismissKeyBoard()
        }
    }
}
