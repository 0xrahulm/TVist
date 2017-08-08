//
//  ListingItemViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingItemViewController: GenericAllItemsListViewController {
    
    
    var listingItem: ListingItem?
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let listingItem = queryParams["listingItem"] as? ListingItem {
            self.listingItem = listingItem
            self.setPrefillItems(prefillItems: listingItem.escapeDataList)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = listingItem?.title
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListingItemViewController.receivedData(notification:)), name: Notification.Name(rawValue:NotificationObservers.ListingItemObserver.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func itemTapEvent(itemName: String, index: Int) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ListingsViewAllPageItemClick, properties: ["Position": "\(index+1)", "ItemName": itemName])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func fetchRequest() {
        if let listingItem = self.listingItem, let listingItemId = listingItem.id {
            ListingsDataProvider.shared.fetchListingItem(itemId: listingItemId, pageNo: nextPage)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func getTrackingPositionName() -> String {
        if let title = listingItem?.title {
            return title
        }
        return "ListingItem"
    }
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["item"] as? ListingItem, let page = data["page"] as? Int {
                if let listingItem = self.listingItem, let listingItemId = listingItem.id, let receivedId = itemsData.id, listingItemId == receivedId {
                    appendDataToBeListed(appendableData: itemsData.escapeDataList, page: page)
                }
                
            }
        }
    }

}
