//
//  BrowseByGenreViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 31/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class BrowseByGenreViewController: GenericAllItemsListViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var genreItem: GenreItem?
    
    var selectedType: FilterType = .All
    
    
    var listOfItemType:[FilterType] = [.All, .Television, .Movie]
    var titleForItem: [FilterType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let genreItem = queryParams["genreItem"] as? GenreItem {
            self.genreItem = genreItem
        }
    }
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        if let genreItem = self.genreItem, let genreName = genreItem.name {
            AnalyticsVader.sharedVader.basicEvents(eventName: .HomeGenrePageSegmentClick, properties: ["GenreName": genreName, "TabName": self.selectedType.rawValue])
        }
        self.selectedType = listOfItemType[sender.selectedSegmentIndex]
        reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = genreItem?.name
        
        NotificationCenter.default.addObserver(self, selector: #selector(BrowseByGenreViewController.receivedData(notification:)), name: Notification.Name(rawValue:NotificationObservers.MediaByGenreDataObserver.rawValue), object: nil)
    }

    override func itemTapEvent(itemName: String, index: Int) {
        if let genreItem = self.genreItem, let genreName = genreItem.name {
            
            AnalyticsVader.sharedVader.basicEvents(eventName: .HomeGenrePageItemClick, properties: ["ItemName": itemName, "Position": "\(index+1)", "GenreName": genreName])
        }
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
        if let genreItem = self.genreItem, let genreId = genreItem.id {
            HomeDataProvider.shared.getItemsByGenre(genreId: genreId, filterType: self.selectedType, page: nextPage)
        }
    }
    
    
    override func getTrackingPositionName() -> String {
        if let title = genreItem?.name {
            return title
        }
        return "BrowseByGenre"
    }

    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["items"] as? [EscapeItem], let page = data["page"] as? Int, let receivedType = data["type"] as? String {
                if page == nextPage, receivedType == self.selectedType.rawValue {
                    appendDataToBeListed(appendableData: itemsData, page: page)
                }
                
            }
        }
    }

}
