//
//  HomeViewController.swift
//  Escape
//
//  Created by Ankit on 03/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum CellIdentifier : String{
    case FBFriends = "FBFriendView"
    case PlaceHolder = "PlaceHolderView"
    case Article = "ArticleView"
    case AddToEscape = "AddToEscapeView"
    case WhatsYourEscape = "WhatsYourEscape"
    case EscapeCollection = "EscapeCollectionView"
    case SuggestedFollow = "SuggestedFollows"
    case SuggestedPeopleCollection = "SuggestedPeopleCollectionView"
}

enum HomeCellIdentifiers: String {
    case MediaWatchlistSection = "MediaWatchlistSection"
    case MediaListCellIdentifier = "MediaListCell"
    case BrowseByGenreCell = "BrowseByGenreCell"
    case MediaListingCellIdentifier = "ListingTableViewCell"
    case ArticlesSectionTableViewCell = "ArticlesSectionTableViewCell"
    case VideosSectionCell = "VideosSectionCell"
    case RemoteConnectBannerCell = "RemoteConnectBannerCell"
}

enum HeightForHomeSection: CGFloat {
    case defaultHeightWatchlist = 50.0
}

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userDetailView: UserDetailView!
    
    var selectedType: FilterType = .All
    var storedOffsets = [Int: CGFloat]()
    
    var listOfItemType:[FilterType] = [.All, .Television, .Movie]
    var titleForItem: [FilterType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    
    var registerableCells: [HomeCellIdentifiers] = [.MediaWatchlistSection,.MediaListCellIdentifier,.MediaListingCellIdentifier,.BrowseByGenreCell,.ArticlesSectionTableViewCell,.VideosSectionCell, .RemoteConnectBannerCell]
    
    var lastScrollValue:String = ""
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    var resetFlag:Bool = false
    
    var homeItems:[HomeItem] = []
    
    var loadedOnce:Bool = false
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        self.selectedType = listOfItemType[sender.selectedSegmentIndex]
        AnalyticsVader.sharedVader.basicEvents(eventName: .HomeSegmentClick, properties: ["Selected Tab":self.selectedType.rawValue])
        reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userDetailView.viewType = "Home"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if homeItems.count == 0 {
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
        return ScreenNames.Home.rawValue
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
        HomeDataProvider.shared.homeDataDelegate = self
        HomeDataProvider.shared.getHomeData(page: nextPage, type: self.selectedType)
    }
    
    
    func appendDataToBeListed(appendableData: [HomeItem], page: Int?) {
        
        loadingView.stopAnimating()
        
        if let page = page, page == nextPage {
            
            nextPage += 1
            if appendableData.count < DataConstants.kDefaultHomeFetchSize {
                fullDataLoaded = true
            } else if page == 1 && !resetFlag {
                AnalyticsVader.sharedVader.basicEvents(eventName: .HomePageLoaded)
            }
            
            if resetFlag {
                resetFlag = false
                homeItems = []
            }
            
            homeItems.append(contentsOf: appendableData)
            tableView.reloadData()
            
            fetchingData = false
        }
        
    }
    
    
    func itemAtIndexPath(indexPath: IndexPath) -> HomeItem {
        return self.homeItems[indexPath.row]
    }
    
}

extension HomeViewController: HomeDataProtocol {
    func didReceiveHomeData(data: [HomeItem], page: Int?) {
        appendDataToBeListed(appendableData: data, page: page)
    }
    
    func errorRecievingHomeData() {
        
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = itemAtIndexPath(indexPath: indexPath)
        
        if item.itemTypeEnumValue() == .remoteBanner {
            return RemoteConnectBannerCell.totalHeight()
        }
        
        var cellHeight = HeightForHomeSection.defaultHeightWatchlist.rawValue
        
        if item.itemTypeEnumValue() == .tracker {
            cellHeight += MediaWatchlistSection.totalHeight(count: item.escapeDataList.count)
        }
        
        if item.itemTypeEnumValue() == .discover {
            cellHeight += CustomListTableViewCell.totalHeight(itemsCount: item.escapeDataList.count)
        }
        
        if item.itemTypeEnumValue() == .listing {
            cellHeight += ListingTableViewCell.totalHeight(count: item.listingsDataList.count)
        }
        
        if item.itemTypeEnumValue() == .genre {
            cellHeight += BrowseByGenreCell.totalHeight(count: item.genreList.count)
        }
        
        if item.itemTypeEnumValue() == .articles {
            cellHeight += ArticlesSectionTableViewCell.totalHeight(count: item.articlesList.count)
        }
        
        if item.itemTypeEnumValue() == .videos {
            cellHeight += VideosSectionCell.totalHeight(count: item.videosList.count)
        }
        
        return cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)*0.66) {
            loadNexPage()
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
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeScreenScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "Segment Tab": self.selectedType.rawValue])
                self.lastScrollValue = scrollBucketStr
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            if self.tableView == scrollView {
                
                
                let percentageScroll:CGFloat = ((scrollView.contentOffset.y+scrollView.frame.size.height)/scrollView.contentSize.height)*100
                let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
                if self.lastScrollValue != scrollBucketStr {
                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeScreenScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "Segment Tab": self.selectedType.rawValue])
                    self.lastScrollValue = scrollBucketStr
                }
                
            }
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAtIndexPath(indexPath: indexPath)
        
        if item.itemTypeEnumValue() == .tracker {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifiers.MediaWatchlistSection.rawValue, for: indexPath) as? MediaWatchlistSection {
                cell.sectionTitleLabel.text = item.title
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .discover {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifiers.MediaListCellIdentifier.rawValue, for: indexPath) as? CustomListTableViewCell {
                cell.cellTitleLabel.text = item.title
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .listing {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifiers.MediaListingCellIdentifier.rawValue, for: indexPath) as? ListingTableViewCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.listingsDataList)
                cell.viewAllTapDelegate = self
                cell.listingSectionDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .genre {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifiers.BrowseByGenreCell.rawValue, for: indexPath) as? BrowseByGenreCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.genreList)
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .articles {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifiers.ArticlesSectionTableViewCell.rawValue, for: indexPath) as? ArticlesSectionTableViewCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.articlesList)
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .videos {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifiers.VideosSectionCell.rawValue, for: indexPath) as? VideosSectionCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.videosList)
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .remoteBanner {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellIdentifiers.RemoteConnectBannerCell.rawValue, for: indexPath) as? RemoteConnectBannerCell {
                cell.titleLabel.text = item.title
                cell.emptyLabel.text = item.emptyMessage
                cell.remoteConnectDelegate = self
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let item = itemAtIndexPath(indexPath: indexPath)
        if let tableViewCell = cell as? CustomListTableViewCell {
            
            tableViewCell.setDataAndInitialiseView(data: item.escapeDataList)
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
            
        }
        
        if let cell = cell as? MediaWatchlistSection {
            if item.escapeDataList.count > 0 {
                cell.setDataAndInitialiseView(data: item.escapeDataList)
            } else if let emptyMessage = item.emptyMessage {
                cell.setEmptyString(emptyString: emptyMessage)
            }
        }
        
        if let cell = cell as? VideosSectionCell {
            cell.willDisplay()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CustomListTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    
}



extension HomeViewController: PrimaryCTATapProtocol {
    func didTapOnPrimaryCTA(collectionView: UICollectionView, cell: UICollectionViewCell) {
//        if let columnIndex = collectionView.indexPath(for: cell) {
//            
//            let item = homeItems[collectionView.tag].escapeDataList[columnIndex.row]
//            
//            if !TrackingDataProvider.shared.dopamineShotShown {
//                TrackingDataProvider.shared.dopamineShotShown = true
//                self.showSpace(title: "\(item.name)", description: "Awesome! you'll now receive notifications for Airtimes, News, Trailers, etc.", spaceOptions: [.spaceStyle(style: .success), .titleFont(font: SFUIAttributedText.getMediumFont(size: 13)), .spaceHideTimer(timer: 3.2), .spaceHeight(height: 80), .spacePosition(position: .top), .descriptionFont(font: SFUIAttributedText.getRegularFont(size: 15))])
//            }
//        }
    }
}

extension HomeViewController: RemoteConnectionPopupDelegate {
    func didTapOnSearchConnectedDevices() {
        ScreenVader.sharedVader.performScreenManagerAction(.OpenDeviceSearchView, queryParams: nil)
    }
}

extension HomeViewController: RemoteConnectBannerProtocol {
    func didTapOnConnectNow() {
        AnalyticsVader.sharedVader.basicEvents(eventName: .HomeRemoteConnectButtonClick)
        LocalStorageVader.sharedVader.setFlagForKey(.DontShowRemoteConnectBanner)
        ScreenVader.sharedVader.performScreenManagerAction(.OpenDeviceSearchView, queryParams: nil)
    }
    
    func didTapOnDoNowShowAgain(cell: RemoteConnectBannerCell) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .HomeRemoteDoNotShowAgainClick)
        LocalStorageVader.sharedVader.setFlagForKey(.DontShowRemoteConnectBanner)
        if let indexPath = self.tableView.indexPath(for: cell) {
            let item = self.homeItems[indexPath.row]
            if let itemId = item.id {
                HomeDataProvider.shared.removeSection(itemId: itemId)
            }
            self.homeItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
}

extension HomeViewController: ListingSectionProtocol {
    func didTapOnChannelNumber(channelNumber: String) {
        if DirecTVader.sharedVader.changeChannel(channelNumber: channelNumber) {
            ScreenVader.sharedVader.makeToast(toastStr: "Channel Changed to \(channelNumber)")
        } else {
            ScreenVader.sharedVader.performScreenManagerAction(.OpenRemoteConnectionPopup, queryParams: ["delegate": self])
        }
    }
}

extension HomeViewController: ViewAllTapProtocol {
    func viewAllTappedIn(_ cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let item = homeItems[indexPath.row]
            
            var eventParams: [String:String] = ["Row":"\(indexPath.row+1)"]
            var eventName: EventName = .HomeSectionViewAllClick
            
            if item.itemTypeEnumValue() == .discover {
                eventName = .HomeDiscoverViewAllClick
                ScreenVader.sharedVader.performScreenManagerAction(.OpenHomeDiscoverItemView, queryParams: ["homeItem":item])
            }
            
            if item.itemTypeEnumValue() == .articles {
                eventName = .HomeArticlesViewAllClick
                if let title = item.title {
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenAllArticlesView, queryParams: ["title": title])
                }
            }
            
            if item.itemTypeEnumValue() == .videos {
                eventName = .HomeVideosViewAllClick
                if let title = item.title {
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenAllVideosView, queryParams: ["title": title])
                }
            }
            
            if item.itemTypeEnumValue() == .genre {
                eventName = .HomeGenreViewAllClick
                ScreenVader.sharedVader.performScreenManagerAction(.OpenAllGenreView, queryParams: nil)
            }
            
            if item.itemTypeEnumValue() == .tracker {
                eventName = .HomeWatchlistViewAllClick
                ScreenVader.sharedVader.performScreenManagerAction(.WatchlistTab, queryParams: nil)
            }
            
            if item.itemTypeEnumValue() == .listing {
                eventName = .HomeAiringNowViewAllClick
                ScreenVader.sharedVader.performScreenManagerAction(.RemoteTab, queryParams: nil)
            }
            
            if let title = item.title {
                eventParams["SectionName"] = title
            }
            
            AnalyticsVader.sharedVader.basicEvents(eventName: eventName, properties: eventParams)
        }
    }
}

