//
//  SearchChildViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class SearchChildViewController: GenericAllItemsListViewController {
    weak var dismissKeyboardDelegate : DismissKeyboardProtocol?
    
    var searchPosition: String = "Guide"
    var type : SearchType = .All
    var searchedText  = ""
    
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        ECUserDefaults.removeSearchedText()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationObservers.SearchObserver.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationObservers.SearchQueryObserver.rawValue), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("didappear : \(type)")
        
        self.loadingView.stopAnimating()
        
        if let text = ECUserDefaults.getSearchedText(){
            self.searchedText = text
        }
        
        
    }
    
    func initObservers(){
        
        // for receiving searched data
        NotificationCenter.default.addObserver(self, selector: #selector(SearchChildViewController.receivedNotification(_:)), name:NSNotification.Name(rawValue: NotificationObservers.SearchObserver.rawValue), object: nil)
        
        // for receiving searched text
        NotificationCenter.default.addObserver(self, selector: #selector(SearchChildViewController.recievedSearchedText(_:)), name:NSNotification.Name(rawValue: NotificationObservers.SearchQueryObserver.rawValue), object: nil)
        
    }
    
    
    func searchCall(_ text : String){
        self.loadingView.startAnimating()
        AnalyticsVader.sharedVader.searchOccurred(searchType: type.rawValue, searchTerm: text)
        DiscoverDataProvider.shareDataProvider.getSearchItems(text, searchType: type, limit: 10, page: nextPage)
    }
    
    
    @objc func recievedSearchedText(_ notification : Notification){
        if let dict = notification.object as? [String:AnyObject] {
            if let text = dict["searchText"] as? String{
                self.searchedText = text
                reset()
            }
        }
    }
    
    
    override func fetchRequest() {
        if let queryText = ECUserDefaults.getSearchedText(){
            if queryText.characters.count < 3 {
                
                self.listItems = []
                tableView.reloadDataAnimated()
                
            } else {
                if nextPage == 1{
                    self.listItems = []
                    
                    tableView.reloadDataAnimated()
                    
                    _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SearchChildViewController.validateSearch(_:)), userInfo: queryText, repeats: false)
                    
                } else {
                    searchCall(queryText)
                }
            }
        }
        
        self.loadingView.stopAnimating()
    }
    
    @objc func receivedNotification(_ notification : Notification){
        if self.listItems.count == 1{
            self.listItems = []
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
                            
                            self.appendDataToBeListed(appendableData: data, page: dict["page"] as? Int)
                        }
                    }
                    
                }
                
            }
        }
    }
    
    
    override func getTrackingPositionName() -> String {
        return "Search"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func scrollEvent() {
        
        if let delegate = dismissKeyboardDelegate{
            delegate.dismissKeyBoard()
        }
    }

}
