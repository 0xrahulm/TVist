//
//  TrackerViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 19/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class TrackerChildViewController: GenericAllItemsListViewController {
    
    @IBOutlet weak var schedulerView: UIView!
    
    
    
    var listType: GuideListType = .Television
    var loadedOnce:Bool = false
    
    @IBOutlet weak var emptyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.shouldHideTabBar = false
        
        if listType == .All {
            self.emptyLabel.text = "Track your favorite Movies & Shows"
        } else if listType == .Television {
            self.emptyLabel.text = "Track your favorite Shows"
        } else {
            self.emptyLabel.text = "Track your favorite Movies"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(TrackerChildViewController.receivedData(notification:)), name: Notification.Name(rawValue:kTrackingDataNotification), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loadedOnce {
            reset()
        }
        loadedOnce = true
    }
    
    override func fetchRequest() {
        
        TrackingDataProvider.shared.fetchTrackingData(page: nextPage, type: listType)
    }
    
    override func getTrackingPositionName() -> String {
        return "TrackerScreen"
    }
    
    @IBAction func tappedOnStarTrackingNow(sender: UIButton) {
        ScreenVader.sharedVader.performScreenManagerAction(.ListingsTab, queryParams: nil)
    }
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let type = data["type"] as? String, type == listType.rawValue {
                
                if let trackedItems = data["trackings"] as? [EscapeItem] {
                    appendDataToBeListed(appendableData: trackedItems, page: data["page"] as? Int)
                    if trackedItems.count == 0 && fullDataLoaded == true {
                        if self.schedulerView.isHidden {
                            self.schedulerView.visibleWithAnimationDuration(0.2)
                        }
                    } else {
                        self.schedulerView.hideWithAnimationAndRemoveView(false, duration: 0.2)
                    }
                    
                }
            }
        }
    }
    
    override func itemTapEvent(itemName: String, index:Int) {
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.OpenTrackedItem, properties: ["Position": "\(index+1)", "ItemName": itemName])
    }

}
