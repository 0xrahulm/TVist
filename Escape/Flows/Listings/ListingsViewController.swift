//
//  ListingsViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

enum ListingsCellIdentifier: String {
    case MediaListCellIdentifier = "MediaListCell"
    case PickChannelCellIdentifier = "PickChannelCell"
    case ListingDatesCellIdentifier = "ListingDatesCell"
    case ChannelListingCell = "ChannelListingCell"
    
}

class ListingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var listingCellIdentifiers:[ListingsCellIdentifier] = [.MediaListCellIdentifier, .PickChannelCellIdentifier, .ListingDatesCellIdentifier]

    var listingItems:[ListingItem] = []
    
    
    var visibleLimit:Int = 3
    var allItemsVisible:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initXibs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListingsViewController.receivedListData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.ListingsDataObserver.rawValue), object: nil)
        
        ListingsDataProvider.shared.fetchListingsData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initXibs() {
        
        for cardType in listingCellIdentifiers {
            tableView.register(UINib(nibName: cardType.rawValue, bundle: nil), forCellReuseIdentifier: cardType.rawValue)
        }
        
    }
    
    
    func receivedListData(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let listData = userInfo["data"] as? ListingIndex {
                listingItems.removeAll()
                listingItems.append(contentsOf: listData.data)
                tableView.reloadData()
                activityIndicator.stopAnimating()
            }
        }
    }

}

extension ListingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let selectedListingItem = listingItems[indexPath.row]
        
        if selectedListingItem.itemTypeEnumValue() == ListingItemType.mediaList {
            return 330
        } else if selectedListingItem.itemTypeEnumValue() == ListingItemType.pickChannel {
            return 800
        }
        
        return 170
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedListingItem = listingItems[indexPath.row]
        
        if selectedListingItem.itemTypeEnumValue() == ListingItemType.mediaList {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ListingsCellIdentifier.MediaListCellIdentifier.rawValue, for: indexPath) as! CustomListTableViewCell
            cell.viewAllTapDelegate = self
            
            if let cellTitle = selectedListingItem.title {
                cell.cellTitleLabel.text = cellTitle
            }
            return cell
            
        } else if selectedListingItem.itemTypeEnumValue() == ListingItemType.listingDays {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListingsCellIdentifier.ListingDatesCellIdentifier.rawValue, for: indexPath) as! ListingDatesCell
            if let cellTitle = selectedListingItem.title {
                cell.cellTitleLabel.text = cellTitle
            }
            cell.setupDatesView(listingDates: ListingsDataProvider.shared.listingDates)
            return cell
        } else if selectedListingItem.itemTypeEnumValue() == .pickChannel {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListingsCellIdentifier.PickChannelCellIdentifier.rawValue, for: indexPath) as! PickChannelCell
            
            if let cellTitle = selectedListingItem.title {
                cell.cellTitleLabel.text = cellTitle
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else{
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
}

extension ListingsViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let escapeItemCell = collectionView.cellForItem(at: indexPath) as? CustomListCollectionViewCell {
            
            escapeItemCell.popTheImage()
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if listingItems.count > collectionView.tag {
            let data = listingItems[collectionView.tag].escapeDataList
            
            if data.endIndex > 0 {
                
                var params : [String:AnyObject] = [:]
                
                params["escapeItem"] = data[indexPath.row]
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataList = listingItems[collectionView.tag].escapeDataList
        return dataList.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItemCollectionViewCell", for: indexPath) as! CustomListCollectionViewCell
        
        
        let item = listingItems[collectionView.tag].escapeDataList
        cell.dataItems = item[indexPath.row]
        cell.primaryCTADelegate = self
        cell.parentCollectionView = collectionView
        return cell
    }
}

extension ListingsViewController: PrimaryCTATapProtocol {
    func didTapOnPrimaryCTA(collectionView: UICollectionView, cell: UICollectionViewCell) {
        if let columnIndex = collectionView.indexPath(for: cell) {
            
            let item = listingItems[collectionView.tag].escapeDataList[columnIndex.row]
            
            if !TrackingDataProvider.shared.dopamineShotShown {
                TrackingDataProvider.shared.dopamineShotShown = true
                self.showSpace(title: "\(item.name)", description: "Awesome! you'll now receive notifications for Airtimes, News, Trailers, etc.", spaceOptions: [.spaceStyle(style: .success), .titleFont(font: SFUIAttributedText.getMediumFont(size: 13)), .spaceHideTimer(timer: 3.2), .spaceHeight(height: 80), .spacePosition(position: .top), .descriptionFont(font: SFUIAttributedText.getRegularFont(size: 15))])
            }
        }
    }
}

extension ListingsViewController: ViewAllTapProtocol {
    func viewAllTappedIn(_ cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let item = listingItems[indexPath.row]
            ScreenVader.sharedVader.performScreenManagerAction(.OpenGuideListView, queryParams: ["guideItem":item])
            
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.GuideViewAllClick, properties: ["Row":"\(indexPath.row+1)"])
        }
    }
}
