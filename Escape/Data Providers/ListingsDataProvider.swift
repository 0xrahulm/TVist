//
//  ListingsDataProvider.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingsDataProvider: CommonDataProvider {
    
    static let shared = ListingsDataProvider()
    
    let channelListing: ChannelListing = ChannelListing()
    
    var listingCategories: [ListingCategory] = []
    var categoryChannels: [ListingCategory:[TvChannel]] = [:]
    var categorySelectedIndex: Int = 0
    
    var listingDates:[ListingDate] = []
    
    func fetchListingsData() {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .Listings, params: nil, delegate: self)
    }
    
    func fetchCategoryChannels(categoryIndex: Int) {
        
        let selectedCategory = listingCategories[categoryIndex]
        
        if let categoryId = selectedCategory.id {
            
            ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .CategoryChannels, params: ["category_id": categoryId, "index": categoryIndex], delegate: self)
        }
    }
    
    
    func fetchListingsForChannel(channel: TvChannel) {
        
        if let channelId = channel.id {
            ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .ChannelListings, params: ["channel_id": channelId], delegate: self)
        }
        
    }
    
    func fetchFullListings(startTime: String, endTime: String?, channel: TvChannel?, isToday: Bool, page: Int?) {
        
        var params: [String:Any] = ["start_time": startTime, "is_today": isToday]
        
        if let categoryId = listingCategories[self.categorySelectedIndex].id {
            params["category_id"] = categoryId
        }
        
        if let channel = channel, let channelId = channel.id {
            params["channel_id"] = channelId
        }
        
        if let endTime = endTime {
            params["endTime"] = endTime
        }
        
        if let page = page {
            params["page"] = page
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .FullListings, params: params, delegate: self)
    }
    
    func channelsForSelectedCategory() -> [TvChannel]? {
        return channelsForCategoryIndex(index: self.categorySelectedIndex)
    }
    
    func channelsForCategoryIndex(index: Int) -> [TvChannel]? {
        return channelsForCategory(category: listingCategories[index])
    }
    
    func channelsForCategory(category: ListingCategory) -> [TvChannel]? {
        return categoryChannels[category]
    }
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .Listings:
                parseListingsData(listingsData: service.outPutResponse as? [String:AnyObject])
                break
            case .FullListings:
                if let fullListingsData = service.outPutResponse as? [Any], let categoryId = service.parameters?["category_id"] as? String {
                    parseFullListings(fullListingData: fullListingsData, categoryId: categoryId, channelId: service.parameters?["channel_id"] as? String, page: service.parameters?["page"] as? Int)
                }
                break
            case .CategoryChannels:
                if let categoryData = service.outPutResponse as? [Any], let params = service.parameters, let index = params["index"] as? Int {
                    parseCategoryChannels(categoryChannels: categoryData, categoryIndex: index)
                }
                break
                
            case .ChannelListings:
                if let channelData = service.outPutResponse as? [Any], let params = service.parameters, let channelId = params["channel_id"] as? String {
                    parseChannelData(channelData: channelData, channelId: channelId)
                }
                break
            default: break
            }
        }
    }
    
    override func serviceError(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .Listings:
                
                break
            default: break
            }
        }
    }
    
    func parseCategoryChannels(categoryChannels: [Any], categoryIndex: Int) {
        
        var tvChannels:[TvChannel] = []
        let forCategory = listingCategories[categoryIndex]
        
        for categoryChannel in categoryChannels {
            if let categoryChannel = categoryChannel as? [String: Any] {
                
                if let tvChannel = TvChannel.createTvChannel(data: categoryChannel) {
                    tvChannels.append(tvChannel)
                }
            }
        }
        
        self.categoryChannels[forCategory] = tvChannels
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.ListingsChannelDataObserver.rawValue), object: nil)
    
    }
    
    func parseChannelData(channelData: [Any], channelId:String) {
        
        var listingData: [ListingMediaItem] = []
        
        for listItem in channelData {
            if let listItem = listItem as? [String:Any] {
                if let item = ListingMediaItem.parseListingMediaItem(listItem) {
                    listingData.append(item)
                }
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.ListingMediaItemsObserver.rawValue), object: nil, userInfo: ["data":listingData, "channel_id": channelId])
        
    }
    
    
    func parseListingCategories(_ listingCategories: [[String:AnyObject]]) {
        for (index,listingCategory) in listingCategories.enumerated() {
            if let listingCategoryData = ListingCategory.createListingCategory(data: listingCategory) {
                if index == categorySelectedIndex {
                    listingCategoryData.isSelected = true
                }
                self.listingCategories.append(listingCategoryData)
            }
        }
    }
    
    
    func parseListingsData(listingsData: [String:AnyObject]?) {
        
        guard let listingsData = listingsData else {
            return
        }
        
        
        guard let userId = listingsData["user_id"] as? String,
            let listData = listingsData["listings_data"] as? [[String:AnyObject]] else {
                return
        }
        
        
        let listingIndex = ListingIndex()
        
        listingIndex.userId = userId
        listingIndex.parseData(listData)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.ListingsDataObserver.rawValue), object: nil, userInfo: ["data":listingIndex])
        
        
    }
    
    
    func parseFullListings(fullListingData: [Any], categoryId: String, channelId: String?, page: Int?) {
        
        
        var channelListings:[ChannelListing] = []
        
        for channelListingData in fullListingData {
            if let channelListingData = channelListingData as? [String: Any] {
                
                if let channelListing = ChannelListing.parseChannelListing(channelListingData) {
                    
                    channelListings.append(channelListing)
                }
            }
        }
        var userInfo:[String: Any] = ["data": channelListings, "categoryId":categoryId]
        if let channelId = channelId {
            userInfo["channelId"] = channelId
        }
        
        if let page = page {
            userInfo["page"] = page
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.FullListingsDataObserver.rawValue), object: nil, userInfo: userInfo)
        
    }
}
