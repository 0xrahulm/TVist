//
//  WatchlistViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import SwipeCellKit

class WatchlistViewController: GenericDetailViewController {
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    // Tool Bar Buttons
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet weak var alertIconButton: UIBarButtonItem!
    
    @IBOutlet weak var emptyTitle: UILabel!
    
    @IBOutlet weak var emptyCTAButton: UIButton!
    
    var selectedListType: FilterType = .All
    var selectedSortType: SortType = .Recency
    var showAlertsOnly: Bool = false
    
    var foundItemsOnce:Bool = false
    
    var showSeen:Bool = false
    
    var supportedSortTypes:[SortType] = [.Recency, .A_Z, .Z_A, .Airing]
    
    var titleForSortTypes:[SortType:String] = [.Recency:"Recently Added", .A_Z: "A -> Z", .Z_A: "Z -> A", .Airing: "Airing First"]

    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let showSeen = queryParams["showSeen"] as? Bool {
            self.showSeen = showSeen
        }
        
    }
    
    var currentEditingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.showSeen {
            self.title = "Seen List"
            self.toolbar.isHidden = true
        }
        
        if let previouslyStoredSortType = LocalStorageVader.sharedVader.valueForStoredKey(.LastSortSelected) as? String {
            if let storedSortType = SortType(rawValue: previouslyStoredSortType) {
                self.selectedSortType = storedSortType
            }
        }
        updateSortButtonTitle()
        self.tableView.backgroundColor = UIColor.styleGuideBackgroundColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WatchlistViewController.receivedData(notification:)), name: Notification.Name(rawValue:kWatchlistDataNotification), object: nil)
        
        self.tableView.estimatedRowHeight = HeightForMediaCell.WatchlistWithAirtime.rawValue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addSegmentedFilterHeader(withSearchBar: false)
        
    }
    
    @IBAction func didTapOnShowOnlyAlertsButton(_ sender: AnyObject) {
        
        if UserDataProvider.sharedDataProvider.premiumOnlyFeature(feature: .filters) {
            AnalyticsVader.sharedVader.basicEvents(eventName: .WatchlistShowAlertsOnlyTap)
            if !showAlertsOnly {
                self.showAlertsOnly = true
                self.alertButton.tintColor = UIColor.styleGuideActionButtonBlue()
                self.alertIconButton.image = UIImage(named: "AlertButtonSelected")
            } else {
                self.showAlertsOnly = false
                self.alertButton.tintColor = UIColor.styleGuideBodyTextColor()
                self.alertIconButton.image = UIImage(named: "AlertButtonUnSelected")
            }
            
            reset()
        }
    }
    
    @IBAction func didTapOnSortButton(_ sender: AnyObject) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .WatchlistSortOptionsTap)
        if UserDataProvider.sharedDataProvider.premiumOnlyFeature(feature: .sorting) {
            
            let alertController = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
            
            for sortType in supportedSortTypes {
                if let titleForSortType = titleForSortTypes[sortType] {
                    
                    let sortAction = UIAlertAction(title: titleForSortType, style: .default, handler: { (action) in
                        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WatchlistSelectedSortOption, properties: ["SortOption":sortType.rawValue])
                        self.selectedSortType(sortType: sortType)
                    })
                    
                    alertController.addAction(sortAction)
                }
            }
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.popoverPresentationController?.barButtonItem = self.sortButton
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func selectedSortType(sortType: SortType) {
        
        self.selectedSortType = sortType
        
        reset()
        
        updateSortButtonTitle()
        LocalStorageVader.sharedVader.storeValueInKey(.LastSortSelected, value: sortType.rawValue)
    }
    
    func updateSortButtonTitle() {
        
        self.sortButton.title = self.selectedSortType.rawValue
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        scrollEvent()
    }
    
    override func supportedCells() -> [GenericDetailCellIdentifiers] {
        return [.watchlistItemCell, .watchlistItemWithAirtime]
    }
    
    func scrollEvent() {
        // override in base class
    }
    
    @IBAction func didTapOnEmptyCTA(_ sender: Any) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .EmptyDiscoverButtonTap)
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.discoverDetailView, queryParams: ["isTopVC":false])
    }
    
    override func fetchRequest() {
        WatchlistDataProvider.shared.fetchWatchlistData(page: nextPage, type: selectedListType, sortType: selectedSortType, showAlertsOnly: showAlertsOnly, isSeen: showSeen)
    }
    
    @objc func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let type = data["type"] as? String, type == selectedListType.rawValue {
                
                if let watchlistItems = data["watchlist"] as? [EscapeItem] {
                    appendDataToBeListed(appendableData: watchlistItems, page: data["page"] as? Int)
                    if self.listItems.count == 0 && fullDataLoaded {
                        
                        if self.emptyView.isHidden {
                            if foundItemsOnce && (self.selectedListType != .All || self.showAlertsOnly) {
                                self.emptyTitle.text = "Zero Results"
                                self.emptyLabel.text = "No Items found for your specified filter."
                                self.emptyCTAButton.isHidden = true
                            } else {
                                
                                if showSeen {
                                    
                                    self.emptyTitle.text = "Your SeenList is empty"
                                    self.emptyCTAButton.isHidden = true
                                    self.emptyLabel.text = "Mark your media seen from Watchlist, once you are done and dusted."
                                } else {
                                 
                                    self.emptyTitle.text = "Your Watchlist is empty"
                                    self.emptyLabel.text = "Keep an organised list of media you have watched and want to watch"
                                    self.emptyCTAButton.isHidden = false
                                }
                            }
                            self.emptyView.visibleWithAnimationDuration(0.2)
                        }
                    } else {
                        if !foundItemsOnce {
                            var eventName: EventName = .WatchlistDataLoaded
                            if showSeen {
                                eventName = .SeenListDataLoaded
                            }
                            AnalyticsVader.sharedVader.basicEvents(eventName: eventName)
                        }
                        
                        foundItemsOnce = true
                        
                        self.emptyView.hideWithAnimationAndRemoveView(false, duration: 0.2)
                    }
                    
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getName() -> String {
        return ScreenNames.Watchlist.rawValue
    }
    
    
    override func selectedFilterType(filterType: FilterType) {
        self.selectedListType = filterType
        var eventName: EventName = EventName.WatchlistSegmentClick
        if showSeen {
            eventName = EventName.SeenListSegmentClick
        }
        AnalyticsVader.sharedVader.basicEvents(eventName: eventName, properties: ["FilterType": self.selectedListType.rawValue])
        reset()
    }
    
    
}

extension WatchlistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let escapeItem = listItems[indexPath.row] as! EscapeItem
        if let _ = escapeItem.nextAirtime {
            return UITableViewAutomaticDimension
        }
        return HeightForMediaCell.WatchlistCell.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let escapeItem = listItems[indexPath.row] as! EscapeItem
        var cellIdentifier = GenericDetailCellIdentifiers.watchlistItemCell.rawValue
        if let _ = escapeItem.nextAirtime {
            cellIdentifier = GenericDetailCellIdentifiers.watchlistItemWithAirtime.rawValue
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MediaWatchlistTableViewCell
        cell.isSeenCell = showSeen
        
        cell.mediaItem = escapeItem
        cell.delegate = self
        cell.mediaWatchlistDelegate = self
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let escapeItem = listItems[indexPath.row] as! EscapeItem
        
        var params : [String:AnyObject] = [:]
        
        params["escapeItem"] = escapeItem
        
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
        var eventName: EventName = EventName.OpenWatchlistedItem
        if showSeen {
            eventName = EventName.OpenSeenlistedItem
        }
        AnalyticsVader.sharedVader.basicEvents(eventName: eventName, properties: ["Position":"\(indexPath.row+1)", "escapeName": escapeItem.name])
    }
   
}

extension WatchlistViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        var actions: [SwipeAction] = []
        
        if showSeen {
            
            let removeAction = SwipeAction(style: .destructive, title: "Remove", handler: { (action, indexPath) in
                
                let escapeItem = self.listItems[indexPath.row] as! EscapeItem
                
                WatchlistDataProvider.shared.removeFromWatchlist(escapeId: escapeItem.id)
                
                AnalyticsVader.sharedVader.basicEvents(eventName: .RemoveSeenItem, properties: ["escapeName":escapeItem.name, "Position":"\(indexPath.row+1)"])
                self.listItems.remove(at: indexPath.row)
                
                self.tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .right)
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
                
            })
            removeAction.image = IonIcons.image(withIcon: ion_ios_trash, size: 30, color: UIColor.white)
            actions = [removeAction]
            
        } else {
            
            let seenAction = SwipeAction(style: .destructive, title: "Seen", handler: { (action, indexPath) in
                
                let escapeItem = self.listItems[indexPath.row] as! EscapeItem
                
                WatchlistDataProvider.shared.markEscapeSeen(escapeId: escapeItem.id)
                AnalyticsVader.sharedVader.basicEvents(eventName: .WatchlistMarkSeenTap, properties: ["escapeName":escapeItem.name, "Position":"\(indexPath.row+1)"])
                self.listItems.remove(at: indexPath.row)
                
                self.tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .right)
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
                
            })
            seenAction.image = IonIcons.image(withIcon: ion_ios_eye, size: 35, color: UIColor.white)
            let editAction = SwipeAction(style: .default, title: "Edit", handler: { (action, indexPath) in
                
                let escapeItem = self.listItems[indexPath.row] as! EscapeItem
                self.currentEditingIndex = indexPath.row
                ScreenVader.sharedVader.performUniversalScreenManagerAction(.openAddToWatchlistView, queryParams: ["mediaItem": escapeItem, "delegate": self])
                
                AnalyticsVader.sharedVader.basicEvents(eventName: .WatchlistEditTap, properties: ["escapeName":escapeItem.name, "Position":"\(indexPath.row+1)"])
            })
            editAction.image = IonIcons.image(withIcon: ion_edit, size: 22, color: UIColor.white)
            editAction.backgroundColor = UIColor.styleGuideActionButtonBlue()
            actions = [seenAction, editAction]
        }
        return actions
        
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = SwipeExpansionStyle.destructiveAfterFill
        options.transitionStyle = .border
        return options
    }
}

extension WatchlistViewController: MediaWatchlistCellProtocol {
    func didTapOnSwipeDetection(cell: UITableViewCell) {
        if let swipeCell = cell as? SwipeTableViewCell {
            swipeCell.showSwipe(orientation: .left, animated: true, completion: nil)
        }
    }
}

extension WatchlistViewController: AddToWatchlistPopupProtocol {
    func addToWatchlistDone(isAlertSet: Bool) {
        if let currentEditingIndex = self.currentEditingIndex {
            if let mediaItem = self.listItems[currentEditingIndex] as? EscapeItem {
                mediaItem.isAlertSet = isAlertSet
                self.tableView.reloadData()
            }
        }
    }
}

