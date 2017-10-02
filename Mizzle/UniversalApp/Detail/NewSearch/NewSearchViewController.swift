//
//  NewSearchViewController.swift
//  TVist
//
//  Created by Rahul Meena on 23/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class NewSearchViewController: GenericDetailViewController {
    
    var selectedType: FilterType = .All
    var searchedText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        
        // for receiving searched data
        NotificationCenter.default.addObserver(self, selector: #selector(NewSearchViewController.receivedNotification(_:)), name:NSNotification.Name(rawValue: NotificationObservers.SearchObserver.rawValue), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !loadedOnce {
            loadedOnce = true
        }
        
        addSegmentedFilterHeader(withSearchBar: true)
        self.theSearchBar?.delegate = self
    }
    
    override func fetchRequest() {
        if searchedText != "" {
         
            DiscoverDataProvider.shareDataProvider.getSearchItem(searchedText, filterType: selectedType, limit: 10, page: nextPage)
        } else {
            self.loadingView.stopAnimating()
        }
    }
    
    override func supportedCells() -> [GenericDetailCellIdentifiers] {
        return [.genericEscapeCell]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.theSearchBar?.becomeFirstResponder()
    }
    
    @objc func receivedNotification(_ notification : Notification){
        if self.listItems.count == 1 {
            self.listItems = []
        }
        
        if let dict = notification.object as? [String:AnyObject]{
            if let type = dict["type"] as? String,
                let searchType = FilterType(rawValue: type),
                let queryText = dict["queryText"] as? String{
                
                if self.selectedType == searchType && queryText == searchedText {
                    if let data = dict["data"] as? [EscapeItem]{
                        if data.count == 0 {
                            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchInvalid)
                        } else {
                            if let page = dict["page"] as? Int {
                                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ItemsShown, properties: ["page":"\(page)"])
                            }
                        }
                        
                        self.appendDataToBeListed(appendableData: data, page: dict["page"] as? Int)
                    }
                }
                
            }
        }
    }
    
    @objc func validateSearch(_ timer : Timer) {
        
        if let text = timer.userInfo as? String {
            if text == searchedText {
                reset()
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func selectedFilterType(filterType: FilterType) {
        self.selectedType = filterType
        
        reset()
    }
    
}

extension NewSearchViewController: UISearchBarDelegate {
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.theSearchBar?.resignFirstResponder()
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchCancelled, properties: ["Position": "Search Tab"])
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchedText = searchText
        
        if searchedText.characters.count < 3 {
            
            self.listItems = []
            tableView.reloadDataAnimated()
            
        } else {
            if nextPage == 1{
                self.listItems = []
                
                tableView.reloadDataAnimated()
                
                _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(NewSearchViewController.validateSearch(_:)), userInfo: searchText, repeats: false)
                
            } else {
                reset()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchClick, properties: ["Position": "Search Float Button"])
        self.theSearchBar?.resignFirstResponder()
    }
}

extension NewSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listItems[indexPath.row] as! EscapeItem
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericDetailCellIdentifiers.genericEscapeCell.rawValue, for: indexPath) as! EscapeCell
        cell.escapeItem = item
        cell.trackPosition = "Search"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let escapeItem = listItems[indexPath.row] as! EscapeItem
        
        var params : [String:AnyObject] = [:]
        
        params["escapeItem"] = escapeItem
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SearchItemClick, properties: ["Position":"Search Float Button"])
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
    }
}
