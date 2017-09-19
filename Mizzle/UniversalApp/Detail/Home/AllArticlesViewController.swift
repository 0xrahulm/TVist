//
//  AllArticlesViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 31/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AllArticlesViewController: GenericAllItemsListViewController {
    
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let title = queryParams["title"] as? String {
            self.title = title
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AllArticlesViewController.receivedData(notification:)), name: Notification.Name(rawValue:NotificationObservers.AllArticlesDataObserver.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func itemTapEvent(itemName: String, index: Int) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .HomeAllArticlesItemClick, properties: ["ArticleTitle":itemName, "Position":"\(index+1)"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func fetchRequest() {
        HomeDataProvider.shared.getAllArticlesData(page: nextPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["items"] as? [ArticleItem], let page = data["page"] as? Int {
                appendDataToBeListed(appendableData: itemsData, page: page)
            }
        }
    }
}
