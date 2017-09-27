//
//  HomeItemViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 31/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class HomeItemViewController: GenericAllItemsListViewController {
    var homeItem: HomeItem?
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let homeItem = queryParams["homeItem"] as? HomeItem {
            self.homeItem = homeItem
            self.setPrefillItems(prefillItems: homeItem.escapeDataList)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = homeItem?.title
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeItemViewController.receivedData(notification:)), name: Notification.Name(rawValue:NotificationObservers.HomeItemDataObserver.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func itemTapEvent(itemName: String, index: Int) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.DiscoverPageItemClick, properties: ["Position": "\(index+1)", "ItemName": itemName])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func fetchRequest() {
        if let homeItem = self.homeItem, let homeItemId = homeItem.id {
            HomeDataProvider.shared.getDiscoverItemData(itemId: homeItemId, pageNumber: nextPage)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func getTrackingPositionName() -> String {
        if let title = homeItem?.title {
            return title
        }
        return "HomeItem"
    }
    
    @objc func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["item"] as? HomeItem, let page = data["page"] as? Int {
                if let homeItem = self.homeItem, let homeItemId = homeItem.id, let receivedId = itemsData.id, homeItemId == receivedId {
                    appendDataToBeListed(appendableData: itemsData.escapeDataList, page: page)
                }
                
            }
        }
    }
    
}
