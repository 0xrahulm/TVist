//
//  GuideListViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 23/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GuideListViewController: GenericAllItemsListViewController {

    var mediaType: EscapeType!
    var guideItem: GuideItem?
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let guideItem = queryParams["guideItem"] as? GuideItem {
            self.guideItem = guideItem
            self.setPrefillItems(prefillItems: guideItem.escapeDataList)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = guideItem?.title
        
        NotificationCenter.default.addObserver(self, selector: #selector(GuideListViewController.receivedData(notification:)), name: Notification.Name(rawValue:kTrackingDataNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func fetchRequest() {
        if let guideItem = self.guideItem, let guideItemId = guideItem.id {
            TvGuideDataProvider.shared.fetchGuideItem(itemId: guideItemId, pageNo: nextPage)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["item"] as? GuideItem, let page = data["page"] as? Int {
                if let guideItem = self.guideItem, let guideItemId = guideItem.id, let receivedId = itemsData.id, guideItemId == receivedId {
                    appendDataToBeListed(appendableData: itemsData.escapeDataList, page: page)
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

}
