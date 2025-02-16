//
//  TvGuideChildViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 12/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit


enum TvGuideCellIdentifier: String {
    case MediaListCellIdentifier = "MediaListCell"

}

class TvGuideChildViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listType: FilterType = .Television
    var titleForItem: [FilterType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    
    var guideItems:[GuideItem] = []
    
    var lastScrollValue:String = ""
    var storedOffsets = [Int: CGFloat]()

    
    var cardsTypeArray: [TvGuideCellIdentifier] = [.MediaListCellIdentifier]
    
    
    // For Analytics
    let letters = (0..<26).map({Character(UnicodeScalar("a".unicodeScalars.first!.value + $0)!)})
    
    
    func initXibs() {
        
        for cardType in cardsTypeArray{
            tableView.register(UINib(nibName: cardType.rawValue, bundle: nil), forCellReuseIdentifier: cardType.rawValue)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initXibs()
        guideItems.append(GuideItem.getLoadingItem())
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TvGuideChildViewController.receivedListData(_:)), name: NSNotification.Name(rawValue: NotificationObservers.TvGuideDataObserver.rawValue), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TvGuideDataProvider.shared.fetchGuideList(listType: listType)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func receivedListData(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            
            
            if let listType = userInfo["type"] as? String, let listTypePresent = FilterType(rawValue: listType) {
                if self.listType == listTypePresent {
                    if let listData = userInfo["data"] as? GuideList {
                        guideItems.removeAll()
                        guideItems.append(contentsOf: listData.data)
                        tableView.reloadData()
                        
//                        AnalyticsVader.sharedVader.basicEvents(eventName: .GuideDataLoaded, properties: ["ListType": self.listType.rawValue])
                    }
                }
            }
        }
    }
    
    
    
    func configureFBFriendCell(_ tableView : UITableView , indexPath : IndexPath, data: FBFriendCard) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.FBFriends.rawValue) as! FBFriendsTableViewCell
        cell.friendItems = data
        cell.indexPath = indexPath
        return cell
    }
    
    func configurePlaceHolderCell(_ tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.PlaceHolder.rawValue, for: indexPath)
        
        return cell
    }
    
    func configureAddToEscapeCell(_ tableView : UITableView, indexPath : IndexPath, data: AddToEscapeCard) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.AddToEscape.rawValue, for: indexPath) as! AddToEscapeTableViewCell
        
        cell.indexPath = indexPath
        cell.escapeItems = data
        return cell
    }

}

extension TvGuideChildViewController: UITableViewDelegate {
    
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
        let percentageScroll:CGFloat = ((scrollView.contentOffset.y+scrollView.frame.size.height)/scrollView.contentSize.height)*100
        let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
        if self.lastScrollValue != scrollBucketStr {
            
//            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.GuideScreenScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "Segment Tab": titleForItem[listType]!])
            self.lastScrollValue = scrollBucketStr
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            
            let percentageScroll:CGFloat = ((scrollView.contentOffset.y+scrollView.frame.size.height)/scrollView.contentSize.height)*100
            let scrollBucketStr = scrollBucket(scrollValue: percentageScroll)
            if self.lastScrollValue != scrollBucketStr {
//                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.GuideScreenScroll, properties: ["percentage":String(format:"%.1f",percentageScroll), "scrollBucket": scrollBucketStr, "Segment Tab": titleForItem[listType]!])
                self.lastScrollValue = scrollBucketStr
            }
            
        }
    }
}

extension TvGuideChildViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let selectedProfileItem = guideItems[indexPath.row]
        
        if selectedProfileItem.itemTypeEnumValue() == GuideItemType.showDiscoverNow {
            return 360
        }
        
        if selectedProfileItem.itemTypeEnumValue() == GuideItemType.userStory {
            if let storyCard = selectedProfileItem.associatedStoryCard, let storyType = storyCard.storyType {
                
                switch storyType {
                    
                case .fbFriendFollow:
                    return 80
                    
                case .addToEscape:
                    return UITableViewAutomaticDimension
                    
                case .recommeded:
                    return UITableViewAutomaticDimension
                    
                case .emptyStory:
                    return 80
                    
                default:
                    return 0
                    
                }
                
            }
        }
        return DataConstants.kHeightForDefaultMediaList
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedProfileItem = guideItems[indexPath.row]
        
        if selectedProfileItem.itemTypeEnumValue() == GuideItemType.showLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLoadingTableViewCellIdentifier") as! CustomLoadingTableViewCell
            
            cell.activityIndicator.startAnimating()
            return cell
        }
        
        if selectedProfileItem.itemTypeEnumValue() == GuideItemType.showDiscoverNow {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierMyAccount.DiscoverNow.rawValue, for: indexPath) as! DiscoverNowViewMyAccountTableViewCell
            cell.message.text = selectedProfileItem.title
            return cell
        }
        
        if selectedProfileItem.itemTypeEnumValue() == GuideItemType.userStory {
            if let storyCard = selectedProfileItem.associatedStoryCard, let storyType = storyCard.storyType {
                
                switch storyType {
                    
                case .fbFriendFollow:
                    if let fbCard = storyCard as? FBFriendCard {
                        
                        return configureFBFriendCell(tableView, indexPath: indexPath, data: fbCard)
                    }
                    break
                case .addToEscape:
                    if let addToEscapeCard = storyCard as? AddToEscapeCard {
                        return configureAddToEscapeCell(tableView, indexPath: indexPath, data: addToEscapeCard)
                    }
                    break
                case .recommeded:
                    if let addToEscapeCard = storyCard as? AddToEscapeCard {
                        return configureAddToEscapeCell(tableView, indexPath: indexPath, data: addToEscapeCard)
                    }
                default:
                    return configurePlaceHolderCell(tableView, indexPath: indexPath)
                }
            }
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TvGuideCellIdentifier.MediaListCellIdentifier.rawValue, for: indexPath) as! CustomListTableViewCell
            
            cell.viewAllTapDelegate = self
            if let cellTitle = selectedProfileItem.title {
                cell.sectionTitleLabel.text = cellTitle
            }
            return cell
        }
        
        return configurePlaceHolderCell(tableView, indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else{
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
}

extension TvGuideChildViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if let escapeItemCell = collectionView.cellForItem(at: indexPath) as? CustomListCollectionViewCell {
            
            escapeItemCell.popTheImage()
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if guideItems.count > collectionView.tag {
            let data = guideItems[collectionView.tag].escapeDataList
            
            if data.endIndex > 0 {
                
                var params : [String:AnyObject] = [:]
                
                params["escapeItem"] = data[indexPath.row]
                
                
//                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.GuideItemClick, properties: ["Grid":"\(letters[indexPath.row])_\(collectionView.tag+1)"])
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataList = guideItems[collectionView.tag].escapeDataList
        return dataList.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItemCollectionViewCell", for: indexPath) as! CustomListCollectionViewCell
        
        
        let item = guideItems[collectionView.tag].escapeDataList
        cell.dataItems = item[indexPath.row]
        cell.primaryCTADelegate = self
        cell.trackPosition = "Guide"
        cell.parentCollectionView = collectionView
        return cell
    }
}

extension TvGuideChildViewController: PrimaryCTATapProtocol {
    func didTapOnPrimaryCTA(collectionView: UICollectionView, cell: UICollectionViewCell) {
        if let columnIndex = collectionView.indexPath(for: cell) {
            
            let item = guideItems[collectionView.tag].escapeDataList[columnIndex.row]
            
            if !TrackingDataProvider.shared.dopamineShotShown {
                TrackingDataProvider.shared.dopamineShotShown = true
                
//                self.showSpace(title: "\(item.name)", description: "Awesome! you'll now receive notifications when it Airs.", spaceOptions: [.spaceStyle(style: .success), .titleFont(font: SFUIAttributedText.getMediumFont(size: 13)), .spaceHideTimer(timer: 3.2), .spaceHeight(height: 80), .spacePosition(position: .top), .descriptionFont(font: SFUIAttributedText.getRegularFont(size: 15))])
            }
        }
    }
}

extension TvGuideChildViewController: ViewAllTapProtocol {
    func viewAllTappedIn(_ cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let item = guideItems[indexPath.row]
            ScreenVader.sharedVader.performScreenManagerAction(.OpenGuideListView, queryParams: ["guideItem":item])
            
//            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.GuideViewAllClick, properties: ["Row":"\(indexPath.row+1)"])
        }
    }
}
