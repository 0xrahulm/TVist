//
//  WatchlistChildViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class WatchlistChildViewController: GenericAllItemsListViewController {
    
    @IBOutlet weak var emptyView: UIView!
    
    
    
    var listType: GuideListType = .Television
    var loadedOnce:Bool = false
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.shouldHideTabBar = false
        
        if listType == .All {
            self.emptyLabel.text = "Add Movies & Shows to Watchlist"
        } else if listType == .Television {
            self.emptyLabel.text = "Add Shows to Watchlist"
        } else {
            self.emptyLabel.text = "Add Movies to Watchlist"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(WatchlistChildViewController.receivedData(notification:)), name: Notification.Name(rawValue:kWatchlistDataNotification), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loadedOnce {
            reset()
        }
        loadedOnce = true
    }
    
    override func fetchRequest() {
        
        WatchlistDataProvider.shared.fetchWatchlistData(page: nextPage, type: listType)
    }
    
    override func getTrackingPositionName() -> String {
        return "Watchlist"
    }
    
    
    @IBAction func tappedOnAddToWatchlistNow(sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.GuideTab, queryParams: nil)
    }
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let type = data["type"] as? String, type == listType.rawValue {
                
                if let watchlistItems = data["watchlist"] as? [EscapeItem] {
                    appendDataToBeListed(appendableData: watchlistItems, page: data["page"] as? Int)
                    if watchlistItems.count == 0 && fullDataLoaded {
                        if self.emptyView.isHidden {
                            self.emptyView.visibleWithAnimationDuration(0.2)
                        }
                    } else {
                        self.emptyView.hideWithAnimationAndRemoveView(false, duration: 0.2)
                    }
                    
                }
            }
        }
    }
    
    override func itemTapEvent(itemName: String, index: Int) {
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.OpenWatchlistedItem, properties: ["Position": "\(index+1)","ItemName": itemName])
    }


}
