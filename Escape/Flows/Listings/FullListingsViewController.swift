//
//  FullListingsViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 29/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import DropDown

class FullListingsViewController: UIViewController {
    
    var startTime: String?
    var endTime:String?
    var selectedChannel: TvChannel?
    var selectedListDate: ListingDate?
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    var resetFlag:Bool = false
    
    var isTodayFlag: Bool = false
    
    var shouldHideTabBar: Bool = true
    
    var listingCellIdentifiers:[ListingsCellIdentifier] = [.ChannelListingCell]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    var channelListings: [ChannelListing] = []
    
    @IBOutlet weak var categorySelectionButton: UIButton!
    @IBOutlet weak var channelSelectionButton: UIButton!
    
    let categoryDropDown:DropDown = DropDown()
    let channelSelectionDropDown:DropDown = DropDown()
    
    var channelsList:[TvChannel] = []
    
    let listingData = ListingsDataProvider.shared
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let selectedListDate = queryParams["selectedListDate"] as? ListingDate {
            self.selectedListDate = selectedListDate
            listDateChange()
        }
        
        self.selectedChannel = queryParams["selectedChannel"] as? TvChannel
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        initXibs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FullListingsViewController.receivedListData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.FullListingsDataObserver.rawValue), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(FullListingsViewController.receivedChannelData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.ListingsChannelDataObserver.rawValue), object: nil)
        
        
        
        setupDatesView(listingDates: listingData.listingDates)
        
        setupCategoriesDropDown()
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupCategoriesDropDown() {
        
        categoryDropDown.anchorView = categorySelectionButton
        
        updateSelectedCategory(index: listingData.categorySelectedIndex)
        
        for eachCategory in listingData.listingCategories {
            if let categoryName = eachCategory.name {
                categoryDropDown.dataSource.append(categoryName)
            }
        }
        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.updateSelectedCategory(index: index)
        }
        
    }
    
    func updateSelectedCategory(index: Int) {
        self.listingData.categorySelectedIndex = index
        
        let selectedCategory = self.listingData.listingCategories[index]
        self.categorySelectionButton.setTitle(selectedCategory.name, for: .normal)
        
        setupChannelsForCategory(index: index)
        self.selectedChannel = nil
        
        reset()
    }
    
    func receivedChannelData(_ notification:Notification) {
        channelSelectionButton.isEnabled = true
        setupChannelsForCategory(index: listingData.categorySelectedIndex)
    }
    
    
    func setupChannelsForCategory(index: Int) {
        channelSelectionDropDown.anchorView = channelSelectionButton
        
        if let channels = listingData.channelsForCategoryIndex(index: index) {
            self.channelsList = channels
            var channelStrings:[String] = []
            channelStrings.append("All Channels")
            
            for eachChannel in channels {
                if let channelName = eachChannel.name {
                    channelStrings.append(channelName)
                }
            }
            
            channelSelectionDropDown.dataSource = channelStrings
            
            channelSelectionDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.channelSelectionButton.setTitle(item, for: .normal)
                self.updateSelectedChannel(index: index)
            }
            
        } else {
            channelSelectionButton.isEnabled = false
            listingData.fetchCategoryChannels(categoryIndex: index)
        }
    }
    
    func updateSelectedChannel(index: Int) {
        if index > 0 { // All Channels
            self.selectedChannel = self.channelsList[index-1]
        } else {
            self.selectedChannel = nil
        }
        reset()
    }
    
    func listDateChange() {
        if let selectedListDate = self.selectedListDate {
            self.startTime = selectedListDate.startTime
            self.endTime = selectedListDate.endTime
            self.isTodayFlag = selectedListDate.isToday
        }
    }
    
    func initXibs() {
        
        for cardType in listingCellIdentifiers {
            tableView.register(UINib(nibName: cardType.rawValue, bundle: nil), forCellReuseIdentifier: cardType.rawValue)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(shouldHideTabBar)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ScreenVader.sharedVader.hideTabBar(false)
    }
    
    func receivedListData(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let listData = userInfo["data"] as? [ChannelListing] {
                
                channelListings.append(contentsOf: listData)
                tableView.reloadData()
                loadingView.stopAnimating()
            }
        }
    }
    
    func reset() {
        nextPage = 1
        fetchingData = false
        fullDataLoaded = false
        resetFlag = true
        self.channelListings.removeAll()
        self.tableView.reloadData()
        
        self.loadingView.startAnimating()
        loadNexPage()
    }
    
    @IBAction func categoryButtonTap(sender: UIButton) {
        categoryDropDown.show()
    }
    
    @IBAction func channelButtonTap(sender: UIButton) {
        channelSelectionDropDown.show()
    }
    
    @IBAction func didPressBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadNexPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            fetchRequest()
        }
    }
    
    func fetchRequest() {
        if let startTime = self.startTime {
            listingData.fetchFullListings(startTime: startTime, endTime: self.endTime, channel: self.selectedChannel, isToday: self.isTodayFlag, page: nextPage)
        }
    }
    
    func setupDatesView(listingDates: [ListingDate]) {
        for (index, listingDate) in listingDates.enumerated() {
            
            if let listingDateView = self.stackView.arrangedSubviews[index] as? ListDateView {
                listingDateView.dateLabel.text = listingDate.dateString
                listingDateView.daysLabel.text = listingDate.label
            }
        }
    }

}

extension FullListingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelListings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channelList = self.channelListings[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListingsCellIdentifier.ChannelListingCell.rawValue, for: indexPath) as? ChannelListingCell {
            cell.cellTitleLabel.text = channelList.channel.name
            cell.channelImageView.downloadImageWithUrl(channelList.channel.imageUrl, placeHolder: IonIcons.image(withIcon: ion_ios_monitor, size: kDefaultIconSize, color: UIColor.buttonGrayColor()))
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ChannelListingCell else{
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
}

extension FullListingsViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let escapeItemCell = collectionView.cellForItem(at: indexPath) as? CustomListCollectionViewCell {
            
            escapeItemCell.popTheImage()
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if channelListings.count > collectionView.tag {
            let data = channelListings[collectionView.tag].programListings
            
            if data.endIndex > 0 {
                
                var params : [String:AnyObject] = [:]
                
                params["escapeItem"] = data[indexPath.row]
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataList = channelListings[collectionView.tag].programListings
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItemCollectionViewCell", for: indexPath) as! CustomListCollectionViewCell
        
        
        let item = channelListings[collectionView.tag].programListings
        cell.mediaItem = item[indexPath.row]
//        cell.primaryCTADelegate = self
        cell.parentCollectionView = collectionView
        return cell
    }
}
