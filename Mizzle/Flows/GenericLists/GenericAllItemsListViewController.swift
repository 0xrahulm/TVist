//
//  GenericAllItemsListViewController.swift
//  Escape
//
//  Created by Rahul Meena on 14/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class GenericAllItemsListViewController: GenericListViewController {
    
    var nextPage = 1
    
    var fetchingData = false
    var fullDataLoaded = false
    var resetFlag:Bool = false
    
    var shouldHideTabBar = false
    
    var listItems:[AnyObject] = []
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let prefillItems = queryParams["prefillItems"] as? [AnyObject], prefillItems.count > 0 {
            setPrefillItems(prefillItems: prefillItems)
        }
    }
    
    func setPrefillItems(prefillItems: [AnyObject]) {
        nextPage = 2
        if prefillItems.count < DataConstants.kDefaultFetchSize {
            fullDataLoaded = true
        }
        listItems = prefillItems
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.startAnimating()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(shouldHideTabBar)
        
        if listItems.count == 0 {
            loadNexPage()
        } else {
            loadingView.stopAnimating()
        }
    }
    
    func loadNexPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            fetchRequest()
        }
    }
    
    func fetchRequest() {
        //Override in child class
    }
    
    func itemTapEvent(itemName: String, index: Int) {
        // Override in child class
    }
    
    func reset() {
        nextPage = 1
        fetchingData = false
        fullDataLoaded = false
        resetFlag = true
        
        self.loadingView.startAnimating()
        fetchRequest()
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
    override func listCount() -> Int {
        return listItems.count
    }
    
    override func listItemAtIndexPath(_ indexPath: IndexPath) -> NormalCell {
        
        
        
        if let escapeItem = listItems[indexPath.row] as? EscapeItem {
            
            let escapeCell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.EscapeCell.rawValue, for: indexPath) as! EscapeCell
            escapeCell.escapeItem = escapeItem
            escapeCell.selectionStyle = .none
            escapeCell.trackPosition = getTrackingPositionName()
            return escapeCell
        }
        
        if let peopleItem = listItems[indexPath.row] as? MyAccountItems {
            let peopleCell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.PeopleCell.rawValue, for: indexPath) as! PeopleCell
            peopleCell.accountItem = peopleItem
            peopleCell.selectionStyle = .none
            return peopleCell
        }
        
        if let listingMediaItem = listItems[indexPath.row] as? ListingMediaItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.ListingMediaDetailsCell.rawValue, for: indexPath) as! ListingMediaDetailsCell
            cell.showFullDate = true
            cell.setupCellForListingMediaItem(listingMediaItem: listingMediaItem)
            return cell
        }
        
        if let articleItem = listItems[indexPath.row] as? ArticleItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.ArticleItemCell.rawValue, for: indexPath) as! ArticleItemCell
            cell.selectionStyle = .none
            cell.articleItem = articleItem
            return cell
            
        }
        
        if let videoItem = listItems[indexPath.row] as? VideoItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: GenericCellIdentifier.SingleVideoSmallCell.rawValue, for: indexPath) as! SingleVideoSmallCell
            cell.videoItem = videoItem
            return cell
        }
        
        return NormalCell()
    }
    
    func getTrackingPositionName() -> String {
        return "Generic"
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if let _ = listItems[indexPath.row] as? EscapeItem {
            return 145
        }
        
        if let _ = listItems[indexPath.row] as? MyAccountItems {
            return 70
        }
        
        if let _ = listItems[indexPath.row] as? ListingMediaItem {
            return 140
        }
        
        
        if let _ = listItems[indexPath.row] as? ArticleItem {
            return 280
        }
        
        if let _ = listItems[indexPath.row] as? VideoItem {
            return HeightForVideosSectionCell.SingleVideoSmallCellHeight.rawValue
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if listItems.count > indexPath.row {
            
            if let data = listItems[indexPath.row] as? EscapeItem {
                
                var params : [String:Any] = [:]
                params["escapeItem"] = data
                itemTapEvent(itemName: data.name, index: indexPath.row)
                ScreenVader.sharedVader.performUniversalScreenManagerAction(.openMediaItemDescriptionView, queryParams: params)
            }
            
            
            if let data = listItems[indexPath.row] as? MyAccountItems {
                if let id  = data.id {
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenUserAccount, queryParams: ["user_id":id, "isFollow" : data.isFollow])
                }
            }
            
            if let listingMediaItem = listItems[indexPath.row] as? ListingMediaItem {
                
                if let escapeItem = EscapeItem.createWithMediaItem(mediaItem: listingMediaItem.mediaItem) {
                    itemTapEvent(itemName: escapeItem.name, index: indexPath.row)
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: ["escapeItem":escapeItem])
                }
            }
            
            if let articleItem = listItems[indexPath.row] as? ArticleItem {
                if let url = URL(string: articleItem.url) {
                    if let title = articleItem.title {
                        itemTapEvent(itemName: title, index: indexPath.row)
                    }
                    ScreenVader.sharedVader.openSafariWithUrl(url: url, readerMode: true)
                }
            }
            
            if let videoItem = listItems[indexPath.row] as? VideoItem {
                if let videoTitle = videoItem.title {
                    itemTapEvent(itemName: videoTitle, index: indexPath.row)
                }
                selectedVideoItem(videoItem: videoItem)
            }
        }
    }
    
    func selectedVideoItem(videoItem: VideoItem) {
        // Override
    }

    func appendDataToBeListed(appendableData: [AnyObject], page: Int?) {
        
        loadingView.stopAnimating()
        
        if let page = page, page == nextPage {
            
            nextPage += 1
            if appendableData.count < DataConstants.kDefaultFetchSize {
                fullDataLoaded = true
            }
            
            if resetFlag {
                resetFlag = false
                listItems = []
            }
            
            listItems.append(contentsOf: appendableData)
            tableView.reloadData()
            
            fetchingData = false
        }
        
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
