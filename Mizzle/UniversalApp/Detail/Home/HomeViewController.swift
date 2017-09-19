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
    case VideosSectionCelliPad = "VideosSectionCelliPad"
    case RemoteConnectBannerCell = "RemoteConnectBannerCell"
}

enum HeightForHomeSection: CGFloat {
    case defaultHeightWatchlist = 45.0
}

enum HomeViewType {
    case today
    case next7Days
    case discover
}

class HomeViewController: GenericDetailViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var thisHomeViewType:HomeViewType = .today
    
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let homeViewType = queryParams["viewType"] as? HomeViewType {
            self.thisHomeViewType = homeViewType
        }
    }
    
    var selectedType: FilterType = .All
    var storedOffsets = [Int: CGFloat]()
    
    var registerableCells: [HomeCellIdentifiers] = [.MediaWatchlistSection,.MediaListCellIdentifier,.MediaListingCellIdentifier,.BrowseByGenreCell,.ArticlesSectionTableViewCell,.VideosSectionCell, .RemoteConnectBannerCell, .VideosSectionCelliPad]
    
    var lastScrollValue:String = ""
    let refreshControl = UIRefreshControl()
    
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        self.selectedType = listOfItemType[sender.selectedSegmentIndex]
        AnalyticsVader.sharedVader.basicEvents(eventName: .HomeSegmentClick, properties: ["Selected Tab":self.selectedType.rawValue])
        reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(HomeViewController.reset), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func supportedCells() -> [GenericDetailCellIdentifiers] {
        return [.mediaWatchlistSection, .browseByGenreCell, .mediaListCellIdentifier, .mediaListingCellIdentifier, .articlesSectionTableViewCell, .videosSectionCell, .videosSectionCelliPad, .remoteConnectBannerCell]
    }
    
    override func getName() -> String {
        return ScreenNames.Home.rawValue
    }
    
    override func fetchRequest() {
        HomeDataProvider.shared.homeDataDelegate = self
        HomeDataProvider.shared.getHomeData(page: nextPage, type: self.selectedType, viewType: self.thisHomeViewType)
    }
    
    
    
    func itemAtIndexPath(indexPath: IndexPath) -> HomeItem {
        return self.listItems[indexPath.row] as! HomeItem
    }
    
    
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
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
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        
        if scrollView == self.tableView {
            
            let percentageScroll:CGFloat = ((scrollView.contentOffset.y+scrollView.frame.size.height)/scrollView.contentSize.height)*100
            let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
            if self.lastScrollValue != scrollBucketStr {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeScreenScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "Segment Tab": self.selectedType.rawValue])
                self.lastScrollValue = scrollBucketStr
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
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

extension HomeViewController: HomeDataProtocol {
    func didReceiveHomeData(data: [HomeItem], page: Int?) {
        appendDataToBeListed(appendableData: data, page: page)
    }
    
    func errorRecievingHomeData() {
        self.refreshControl.endRefreshing()
        self.loadingView.stopAnimating()
    }
}


extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAtIndexPath(indexPath: indexPath)
        
        if item.itemTypeEnumValue() == .tracker {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: GenericDetailCellIdentifiers.mediaWatchlistSection.rawValue, for: indexPath) as? MediaWatchlistSection {
                cell.sectionTitleLabel.text = item.title
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .discover {
            if let cell = tableView.dequeueReusableCell(withIdentifier: GenericDetailCellIdentifiers.mediaListCellIdentifier.rawValue, for: indexPath) as? CustomListTableViewCell {
                cell.sectionTitleLabel.text = item.title
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .listing {
            if let cell = tableView.dequeueReusableCell(withIdentifier: GenericDetailCellIdentifiers.mediaListingCellIdentifier.rawValue, for: indexPath) as? ListingTableViewCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.listingsDataList)
                cell.viewAllTapDelegate = self
                cell.listingSectionDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .genre {
            if let cell = tableView.dequeueReusableCell(withIdentifier: GenericDetailCellIdentifiers.browseByGenreCell.rawValue, for: indexPath) as? BrowseByGenreCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.genreList)
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .articles {
            if let cell = tableView.dequeueReusableCell(withIdentifier: GenericDetailCellIdentifiers.articlesSectionTableViewCell.rawValue, for: indexPath) as? ArticlesSectionTableViewCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.articlesList)
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .videos {
            var identifier = GenericDetailCellIdentifiers.videosSectionCell.rawValue
            if UI_USER_INTERFACE_IDIOM() == .pad {
                identifier = GenericDetailCellIdentifiers.videosSectionCelliPad.rawValue
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? VideosSectionCell {
                cell.sectionTitleLabel.text = item.title
                cell.setDataAndInitialiseView(data: item.videosList)
                cell.viewAllTapDelegate = self
                return cell
            }
        } else if item.itemTypeEnumValue() == .remoteBanner {
            if let cell = tableView.dequeueReusableCell(withIdentifier: GenericDetailCellIdentifiers.remoteConnectBannerCell.rawValue, for: indexPath) as? RemoteConnectBannerCell {
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
            let item = self.listItems[indexPath.row] as! HomeItem
            if let itemId = item.id {
                HomeDataProvider.shared.removeSection(itemId: itemId)
            }
            self.listItems.remove(at: indexPath.row)
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
            let item = listItems[indexPath.row] as! HomeItem
            
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

