//
//  TrackerViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 19/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class TrackerViewController: GenericAllItemsListViewController {
    
    @IBOutlet weak var schedulerView: UIView!

    var loadedOnce:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.shouldHideTabBar = false
        self.title = "Tracker"
        
        NotificationCenter.default.addObserver(self, selector: #selector(TrackerViewController.receivedData(notification:)), name: Notification.Name(rawValue:kTrackingDataNotification), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loadedOnce {
            reset()
        } else {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomePageOpened)
        }
        loadedOnce = true
    }
    
    override func fetchRequest() {
        
        TrackingDataProvider.shared.fetchTrackingData(page: nextPage)
    }
    
    
    @IBAction func tappedOnStarTrackingNow(sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.GuideTab, queryParams: nil)
    }
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let trackedItems = data["trackings"] as? [EscapeItem] {
                if trackedItems.count == 0 {
                    if self.schedulerView.isHidden {
                        self.schedulerView.visibleWithAnimationDuration(0.2)
                    }
                } else {
                    self.schedulerView.hideWithAnimationAndRemoveView(false, duration: 0.2)
                }
                appendDataToBeListed(appendableData: trackedItems, page: data["page"] as? Int)
            }
        }
    }
    
    override func itemTapEvent(itemName: String) {
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.OpenTrackedItem, properties: ["ItemName": itemName])
    }

}
