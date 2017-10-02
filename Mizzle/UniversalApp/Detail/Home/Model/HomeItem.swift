//
//  HomeItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class HomeItem: NSObject {
    var title:String?
    var emptyMessage: String?
    var itemType:Int = -1 // Default is Loading
    var escapeDataList:[EscapeItem] = []
    var listingsDataList: [ListingMediaItem] = []
    var articlesList: [ArticleItem] = []
    var videosList: [VideoItem] = []
    var genreList: [GenreItem] = []
    var channelList: [TvChannel] = []
    var totalItemsCount:Int = 0
    
    var id: String?
    
    init(itemType: HomeItemType) {
        self.itemType = itemType.rawValue
    }
    
    
    func itemTypeEnumValue() -> HomeItemType {
        return HomeItemType(rawValue: itemType)! // Bang because itemType will always be present, without which a profile item is useless
    }
    
    
    func parseDataList(_ dataList: [[String:AnyObject]]) {
        
        switch itemTypeEnumValue() {
        case .todayItem:
            fallthrough
        case .next7DaysItem:
            fallthrough
        case .discover:
            parseEscapesData(dataList)
            break
        case .tracker:
            parseEscapesData(dataList)
            break
        case .articles:
            parseArticleItems(dataList)
            break
        case .videos:
            parseVideoItems(dataList)
            break
        case .genre:
            parseGenreItems(dataList)
            break
        case .listing:
            parseListingMediaItem(dataList)
            break
        case .channelList:
            parseChannelListItem(dataList)
        case .showLoading:
            break
        case .remoteBanner:
            break
        }
    }
    
    class func createHomeItem(homeData: [String:Any]) -> HomeItem? {
        
        guard let itemTypeRaw = homeData["item_type"] as? Int, let itemType = HomeItemType(rawValue: itemTypeRaw) else {
            return nil
        }
        
        let listItem = HomeItem(itemType: itemType)
        listItem.id = homeData["id"] as? String
        
        listItem.title =  homeData["section_title"] as? String
        
        if let total_count = homeData["total_items_count"] as? NSNumber {
            listItem.totalItemsCount = total_count.intValue
        }
        
        if let listedData = homeData["data"] as? [[String:AnyObject]] {
            listItem.parseDataList(listedData)
        }
        
        listItem.emptyMessage = homeData["empty_message"] as? String
        
        
        return listItem
    }
    
    class func getLoadingItem() -> HomeItem {
        return HomeItem(itemType: HomeItemType.showLoading)
    }
    
    func parseEscapesData(_ escapesData: [[String:AnyObject]]) {
        for eachEscapeData in escapesData {
            guard let id = eachEscapeData["id"] as? String, let name = eachEscapeData["name"] as? String, let escapeType = eachEscapeData["escape_type"] as? String else {
                continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(id, name: name, escapeType: escapeType, posterImage: eachEscapeData["poster_image"] as? String, year: eachEscapeData["year"] as? String, rating: eachEscapeData["rating"] as? NSNumber, subTitle: eachEscapeData["subtitle"] as? String, createdBy: eachEscapeData["creator"] as? String, _realm: nil, nextAirtime: eachEscapeData["next_airtime"] as? [String:Any])
            
            if let isTracking = eachEscapeData["is_tracking"] as? Bool {
                escapeItem.isAlertSet = isTracking
            }
            if let hasActed = eachEscapeData["is_acted"] as? Bool {
                escapeItem.hasActed = hasActed
            }
            escapeDataList.append(escapeItem)
            
        }
    }
    
    func parseChannelListItem(_ channelListData: [[String:Any]]) {
        
        for eachItem in channelListData {
            if let tvChannel = TvChannel.createTvChannel(data: eachItem) {
                channelList.append(tvChannel)
            }
        }
    }
    
    func parseListingMediaItem(_ programListings: [[String:Any]]) {
        
        for programListing in programListings {
            if let programListItem = ListingMediaItem.parseListingMediaItem(programListing) {
                listingsDataList.append(programListItem)
            }
        }
    }
    
    func parseArticleItems(_ articlesData: [[String:Any]]) {
        
        for articleData in articlesData {
            if let articleItem = ArticleItem.parseArticleItemData(articleData) {
                articlesList.append(articleItem)
            }
        }
        
    }
    
    func parseVideoItems(_ videosData: [[String:Any]]) {
        
        for videoData in videosData {
            if let videoItem = VideoItem.parseVideoItemData(videoData) {
                videosList.append(videoItem)
            }
        }
        
    }
    
    func parseGenreItems(_ genresData: [[String:Any]]) {
        
        for genreData in genresData {
            if let genreItem = GenreItem.parseGenreItemData(genreData) {
                genreList.append(genreItem)
            }
        }
        
    }
}
