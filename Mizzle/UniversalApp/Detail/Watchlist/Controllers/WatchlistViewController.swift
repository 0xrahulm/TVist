//
//  WatchlistViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class WatchlistViewController: GenericDetailViewController {
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    // Tool Bar Buttons
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    @IBOutlet weak var alertButton: UIBarButtonItem!
    @IBOutlet weak var alertIconButton: UIBarButtonItem!
    
    var selectedListType: FilterType = .All
    
    var showAlertsOnly: Bool = false
    
    var shouldHideTabBar = false
    
    var supportedSortTypes:[SortType] = [.Recency, .A_Z, .Z_A, .Airing]
    
    var titleForSortTypes:[SortType:String] = [.Recency:"Recently Added", .A_Z: "A -> Z", .Z_A: "Z -> A", .Airing: "Airing First"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.styleGuideBackgroundColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WatchlistViewController.receivedData(notification:)), name: Notification.Name(rawValue:kWatchlistDataNotification), object: nil)
        
        self.tableView.estimatedRowHeight = HeightForMediaCell.WatchlistWithAirtime.rawValue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addSegmentedFilterHeader()
        
    }
    
    func setupToolBarItems() {
        
        let showAlertsOnlyButton: UIButton = UIButton(type: .custom)
        
        showAlertsOnlyButton.setImage(UIImage(named: "AlertButtonSelected"), for: .selected)
        showAlertsOnlyButton.setImage(UIImage(named: "AlertButtonUnSelected"), for: .normal)
        
        showAlertsOnlyButton.setAttributedTitle(SFUIAttributedText.mediumAttributedTextForString("Alerts Only", size: 17, color: UIColor.styleGuideMainTextColor()), for: .normal)
        
        let barButton1 = UIBarButtonItem(image: UIImage(named: "AlertButtonUnSelected"), landscapeImagePhone: UIImage(named: "AlertButtonSelected"), style: .plain, target: self, action: nil)
        let barButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let barButton3 = UIBarButtonItem(image: UIImage(named: "SortIcon"), landscapeImagePhone: UIImage(named: "SortIcon"), style: .plain, target: self, action: nil)
        self.toolbar.setItems([barButton1, barButton2, barButton3], animated: true)
        
        
        
    }
    
    @IBAction func didTapOnShowOnlyAlertsButton(_ sender: AnyObject) {
        if !showAlertsOnly {
            self.showAlertsOnly = true
            self.alertButton.tintColor = UIColor.styleGuideActionButtonBlue()
            self.alertIconButton.image = UIImage(named: "AlertButtonSelected")
        } else {
            self.showAlertsOnly = false
            self.alertButton.tintColor = UIColor.styleGuideBodyTextColor()
            self.alertIconButton.image = UIImage(named: "AlertButtonUnSelected")
        }
    }
    
    @IBAction func didTapOnSortButton(_ sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        for sortType in supportedSortTypes {
            if let titleForSortType = titleForSortTypes[sortType] {
                
                let sortAction = UIAlertAction(title: titleForSortType, style: .default, handler: { (action) in
                    self.selectedSortType(sortType: sortType)
                })
                
                alertController.addAction(sortAction)
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.barButtonItem = self.sortButton
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func selectedSortType(sortType: SortType) {
        self.sortButton.title = sortType.rawValue
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
    
    override func fetchRequest() {
        WatchlistDataProvider.shared.fetchWatchlistData(page: nextPage, type: selectedListType)
    }
    
    @objc func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let type = data["type"] as? String, type == selectedListType.rawValue {
                
                if let watchlistItems = data["watchlist"] as? [EscapeItem] {
                    appendDataToBeListed(appendableData: watchlistItems, page: data["page"] as? Int)
                    if self.listItems.count == 0 && fullDataLoaded {
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getName() -> String {
        return ScreenNames.Watchlist.rawValue
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
        cell.mediaItem = escapeItem
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let escapeItem = listItems[indexPath.row] as! EscapeItem
        
        var params : [String:AnyObject] = [:]
        
        params["escapeItem"] = escapeItem
        
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
        
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.OpenWatchlistedItem, properties: ["Position":"\(indexPath.row+1)", "escapeName": escapeItem.name])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let seenAction = UITableViewRowAction(style: .destructive, title: "Seen") { (action, indexPath) in
            
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            
        }
        
        editAction.backgroundColor = UIColor.styleGuideActionButtonBlue()
        
        return [seenAction, editAction]
    }
}

