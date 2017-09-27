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
    var styleGuideSegmentControl: StyleGuideSegmentControl?
    
    var listOfItemType:[FilterType] = [.All, .Television, .Movie]
    var titleForItem: [FilterType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let genreItem = queryParams["genreItem"] as? GenreItem {
            self.genreItem = genreItem
        }
    }
    
    
    
    func addSegmentedFilterHeader() {
        
        let totalHeight = ViewConstants.segmentedHeaderHeightView
        let yOffsetForSegmentedView:CGFloat = 0
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: totalHeight))
        headerView.translatesAutoresizingMaskIntoConstraints = true
        headerView.center = CGPoint(x: self.tableView.bounds.midX, y: ViewConstants.segmentedHeaderHeightView/2)
        headerView.autoresizingMask = [.flexibleWidth]
        
        
        headerView.backgroundColor = UIColor.styleGuideBackgroundColor2()
        
        
        styleGuideSegmentControl = StyleGuideSegmentControl(frame: CGRect(x: ViewConstants.styleGuideDefaultMargin, y: yOffsetForSegmentedView, width: headerView.bounds.width-(2*ViewConstants.styleGuideDefaultMargin), height: ViewConstants.segmentedControlHeight))
        
        if let styleGuideSegmentControl = styleGuideSegmentControl {
            styleGuideSegmentControl.translatesAutoresizingMaskIntoConstraints = true
            styleGuideSegmentControl.delegate = self
            styleGuideSegmentControl.center = CGPoint(x: headerView.center.x, y: headerView.center.y+yOffsetForSegmentedView)
            styleGuideSegmentControl.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            styleGuideSegmentControl.selectedIndex = 0
            
            for listType in listOfItemType {
                if let titleForType = titleForItem[listType] {
                    
                    styleGuideSegmentControl.segments.append(TextSegment(text: titleForType))
                }
            }
            
            headerView.addSubview(styleGuideSegmentControl)
        }
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: headerView.bounds.height-0.5, width: headerView.bounds.width, height: 0.5))
        bottomLine.center = CGPoint(x: headerView.bounds.midX, y: headerView.bounds.height-0.5)
        bottomLine.translatesAutoresizingMaskIntoConstraints = true
        bottomLine.autoresizingMask = [.flexibleWidth]
        bottomLine.backgroundColor = UIColor.styleGuideLineGray()
        
        headerView.addSubview(bottomLine)
        
        self.tableView.tableHeaderView = headerView
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
        addSegmentedFilterHeader()
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

    
    @objc func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["items"] as? [EscapeItem], let page = data["page"] as? Int, let receivedType = data["type"] as? String {
                if page == nextPage, receivedType == self.selectedType.rawValue {
                    appendDataToBeListed(appendableData: itemsData, page: page)
                }
                
            }
        }
    }

}

extension BrowseByGenreViewController: WBSegmentControlDelegate {
    func segmentControl(_ segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {
        let filter = listOfItemType[newIndex]
        self.selectedType = filter
        
        reset()
    }
}
