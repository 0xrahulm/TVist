//
//  RemoteViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 30/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import DropDown

enum RemoteCellIdentifiers: String {
    case ChannelPlayWithAiringNowCell = "ChannelPlayWithAiringNowCell"
}

enum HeightForRemoteCell: CGFloat {
    case DefaultHeight = 125.0
}

class RemoteViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    let categoryDropDown:DropDown = DropDown()
    let defaultCategoryString = "All Channels"
    var selectedType: FilterType = .All
    var storedOffsets = [Int: CGFloat]()
    var lastScrollValue:String = ""
    
    var listOfItemType:[FilterType] = [.All, .Television, .Movie]
    var titleForItem: [FilterType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    
    var registerableCells: [RemoteCellIdentifiers] = [.ChannelPlayWithAiringNowCell]
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    var resetFlag:Bool = false
    
    var remoteItems:[ListingMediaItem] = []
    var categories: [ListingCategory] = []
    
    var selectedCategoryId: String?
    var searchedChannelNumber: String?
    
    var loadedOnce: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TvRemoteDataProvider.shared.remoteDataDelegate = self
        TvRemoteDataProvider.shared.getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if remoteItems.count == 0 {
            loadNexPage()
        } else {
            loadingView.stopAnimating()
        }
        
        if loadedOnce {
            reset()
        } else {
            initXibs()
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
        loadedOnce = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !LocalStorageVader.sharedVader.flagValueForKey(.DontShowRemoteConnectBanner) {
            
            if DirecTVader.sharedVader.getTuned() {
                
            } else {
                ScreenVader.sharedVader.performScreenManagerAction(.OpenRemoteConnectionPopup, queryParams: ["delegate": self])
            }
        }
    }
    
    func loadNexPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            fetchRequest()
        }
    }
    
    func initXibs() {
        for genericCell in registerableCells {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
    
    override func getName() -> String {
        return ScreenNames.Remote.rawValue
    }
    
    func reset() {
        nextPage = 1
        fetchingData = false
        fullDataLoaded = false
        resetFlag = true
        
        fetchRequest()
    }
    
    func fetchRequest() {
        self.loadingView.startAnimating()
        TvRemoteDataProvider.shared.remoteDataDelegate = self
        TvRemoteDataProvider.shared.getAiringNow(page: nextPage, categoryId: self.selectedCategoryId, channelNumber: self.searchedChannelNumber)
        
    }
    
    
    
    func appendDataToBeListed(appendableData: [ListingMediaItem], page: Int?) {
        
        loadingView.stopAnimating()
        
        if let page = page, page == nextPage {
            
            nextPage += 1
            if appendableData.count < DataConstants.kDefaultHomeFetchSize {
                fullDataLoaded = true
            }
            
            if resetFlag {
                resetFlag = false
                remoteItems = []
            }
            
            remoteItems.append(contentsOf: appendableData)
            tableView.reloadData()
            
            fetchingData = false
        }
        
    }
    
    func resetCategoryFilter() {
        self.selectedCategoryId = nil
        self.categoryButton.setTitle(defaultCategoryString, for: .normal)
        categoryDropDown.selectRow(at: 0)
    }
    
    func validateSearch(_ timer : Timer){
        
        if let text = timer.userInfo as? String, let searchedText = self.searchedChannelNumber {
            if text == searchedText {
                if text.characters.count < 3 {
                    self.searchedChannelNumber = nil
                } else {
                    AnalyticsVader.sharedVader.basicEvents(eventName: .RemoteChannelNumberSearched, properties: ["SearchedNumber": text])
                }
                reset()
            }
        }
        
    }
    
    @IBAction func categoryButtonTap(sender: UIButton) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .RemoteChannelFilterClick)
        categoryDropDown.show()
    }
    
    
    func setupCategoriesDropDown() {
        
        categoryDropDown.anchorView = categoryButton
        categoryDropDown.dataSource.append(defaultCategoryString)
        for eachCategory in self.categories {
            if let categoryName = eachCategory.name {
                categoryDropDown.dataSource.append(categoryName)
            }
        }
        
        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.updateSelectedCategory(index: index)
        }
        
    }
    
    func updateSelectedCategory(index: Int) {
        
        var arrayIndex = -1
        
        self.searchBar.text = nil
        self.searchedChannelNumber = nil
        
        if index == 0 {
            self.selectedCategoryId = nil
            self.categoryButton.setTitle(defaultCategoryString, for: .normal)
            AnalyticsVader.sharedVader.basicEvents(eventName: .RemoteChannelFilterSelected, properties: ["Category": defaultCategoryString])
        } else {
            arrayIndex += index
            
            let selectedCategory = self.categories[arrayIndex]
            self.selectedCategoryId = selectedCategory.id
            
            self.categoryButton.setTitle(selectedCategory.name, for: .normal)
            if let categoryName = selectedCategory.name {
                
                AnalyticsVader.sharedVader.basicEvents(eventName: .RemoteChannelFilterSelected, properties: ["Category": categoryName])
            }
        }
        reset()
    }

}


extension RemoteViewController: RemoteConnectionPopupDelegate {
    func didTapOnSearchConnectedDevices() {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenDeviceSearchView, queryParams: nil)
    }
}

extension RemoteViewController: RemoteDataProtocol {
    func didReceiveRemoteData(data: [ListingMediaItem], page: Int?) {
        appendDataToBeListed(appendableData: data, page: page)
    }
    func errorRecievingRemoteData() {
        
    }
    
    func didReceiveCategories(data: [ListingCategory]) {
        self.categories = data
        setupCategoriesDropDown()
    }
    
    func errorRecievingCategories() {
        
    }
}


extension RemoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaItem = self.remoteItems[indexPath.row]
        if let channelNumber = mediaItem.channelItem?.number {
            if let escapeName = mediaItem.mediaItem.name {
                
                var params:[String: String] = ["escapeName": escapeName]
                
                if let finishPercent = mediaItem.finishPercentage {
                    params["PercentFinish"] = String(format:"%.1f",finishPercent)
                }
                
                if let channelName = mediaItem.channelItem?.name {
                    params["channelName"] = channelName
                }
                
                AnalyticsVader.sharedVader.basicEvents(eventName: .RemoteItemClick, properties: params)
            }
            
            if DirecTVader.sharedVader.changeChannel(channelNumber: channelNumber) {
                ScreenVader.sharedVader.makeToast(toastStr: "Channel Changed to \(channelNumber)")
            } else {
                ScreenVader.sharedVader.performScreenManagerAction(.OpenRemoteConnectionPopup, queryParams: ["delegate": self])
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightForRemoteCell.DefaultHeight.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remoteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.remoteItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RemoteCellIdentifiers.ChannelPlayWithAiringNowCell.rawValue, for: indexPath) as! ChannelPlayWithAiringNowCell
        
        cell.mediaItem = item
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)*0.66) {
            loadNexPage()
        }
        
        if self.searchBar.isFirstResponder {
            self.searchBar.resignFirstResponder()
        }
        
        scrollEvent()
        
    }
    
    func scrollEvent() {
        // override in base class
    }
    
    func scrollBucket(scrollValue: CGFloat) -> String {
        
        if scrollValue < 30.0 {
            return "0-30"
        }
        if scrollValue >= 30.0 && scrollValue < 60.0 {
            return "30-60"
        }
        if scrollValue >= 60.0 && scrollValue <= 90.0 {
            return "60-90"
        }
        
        if scrollValue > 120 {
            return "> 120"
        }
        
        if scrollValue > 90 {
            return "> 90"
        }
        
        return "Unknown"
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.tableView {
            
            let percentageScroll:CGFloat = ((scrollView.contentOffset.y+scrollView.frame.size.height)/scrollView.contentSize.height)*100
            let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
            if self.lastScrollValue != scrollBucketStr {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.RemoteScreenScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr])
                self.lastScrollValue = scrollBucketStr
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            
            if scrollView == self.tableView {
                
                let percentageScroll:CGFloat = ((scrollView.contentOffset.y+scrollView.frame.size.height)/scrollView.contentSize.height)*100
                let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
                if self.lastScrollValue != scrollBucketStr {
                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.RemoteScreenScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr])
                    self.lastScrollValue = scrollBucketStr
                }
            }
            
        }
    }

}

extension RemoteViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .RemoteChannelSearchCancelled)
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        AnalyticsVader.sharedVader.basicEvents(eventName: .RemoteChannelSearchClick)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchedChannelNumber = searchText
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RemoteViewController.validateSearch(_:)), userInfo: searchText, repeats: false)
        if searchText.characters.count >= 3 {
            resetCategoryFilter()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
}
