//
//  HomeDataProvider.swift
//  Escape
//
//  Created by Ankit on 04/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol HomeDataProtocol:class {
    func didReceiveHomeData(data: [HomeItem], page: Int?)
    func errorRecievingHomeData()
}

protocol GenreDataProtocol: class {
    func didReceiveAllGenreItems(items: [GenreItem])
    func errorRecievingGenreData()
}

class HomeDataProvider: CommonDataProvider {
    static let shared = HomeDataProvider()
    
    weak var homeDataDelegate: HomeDataProtocol?
    weak var genreDataDelegate: GenreDataProtocol?
    
    func getHomeData(page: Int, type: FilterType) {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .HomeData, params: ["page":page, "type":type.rawValue], delegate: self)
    }
    
    func getDiscoverItemData(itemId: String, pageNumber: Int?) {
        
        var params:[String:Any] = ["item_id": itemId]
        
        if let pageNo = pageNumber {
            params["page"] = pageNo
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .HomeDiscoverItem, params: params, delegate: self)
    }
    
    func getItemsByGenre(genreId: String, filterType: FilterType?, page: Int?) {
        var params:[String:Any] = ["genre_id": genreId]
        
        if let page = page {
            params["page"] = page
        }
        
        if let filterType = filterType {
            params["type"] = filterType.rawValue
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .MediaByGenre, params: params, delegate: self)
    }
    
    func getAllArticlesData(page: Int?) {
        var params: [String:Any] = [:]
        if let page = page {
            params["page"] = page
        }
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .HomeAllArticles, params: params, delegate: self)
    }
    
    func getAllVideosData(page: Int?) {
        var params: [String:Any] = [:]
        if let page = page {
            params["page"] = page
        }
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .HomeAllVideos, params: params, delegate: self)
    }
    
    func getAllGenreData() {
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .HomeAllGenres, params: nil, delegate: self)
    }
    
    func removeSection(itemId: String) {
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .HomeRemoveSection, params: ["item_id":itemId], delegate: self)
    }
    
    override func serviceSuccessfull(_ service: Service) {
        
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
            case .HomeData:
                if let response = service.outPutResponse as? [Any] {
                    parseHomeData(homeData: response, page: service.parameters?["page"] as? Int)
                } else {
                    errorFetchingHome()
                }
                break
                
            case .HomeDiscoverItem:
                if let params = service.parameters {
                    parseHomeDiscoverItemData(discoverItemData: service.outPutResponse as? [String:AnyObject], page: params["page"] as? Int)
                }
                break
            case .HomeAllGenres:
                parseAllGenreData(data: service.outPutResponse as? [Any])
                break
            case .HomeAllArticles:
                if let params = service.parameters {
                    parseAllArticlesData(data: service.outPutResponse as? [Any], page: params["page"] as? Int)
                }
                break
            case .HomeAllVideos:
                if let params = service.parameters {
                    parseAllVideosData(data: service.outPutResponse as? [Any], page: params["page"] as? Int)
                }
                break
            case .MediaByGenre:
                if let params = service.parameters {
                    parseMediaByGenreData(data: service.outPutResponse as? [Any], page: params["page"] as? Int, type: params["type"] as? String)
                }
                break
            default: break
            }
        }
    }
    
    override func serviceError(_ service: Service) {
        
        if let subServiceType = service.subServiveType {
            switch subServiceType {
            case .HomeData:
                errorFetchingHome()
                break
            default: break
            }
        }
    }
    
    
    //MARK: - Parsers
    
    func parseAllGenreData(data: [Any]?) {
        guard let genreData = data else { return }
        
        var genreItems: [GenreItem] = []
        
        for eachData in genreData {
            guard let eachData = eachData as? [String: Any], let genreItem = GenreItem.parseGenreItemData(eachData) else { return }
            
            genreItems.append(genreItem)
        }
        
        
        if let genreDataDelegate = self.genreDataDelegate {
            genreDataDelegate.didReceiveAllGenreItems(items: genreItems)
        }
        
    }
    
    func parseAllArticlesData(data: [Any]?, page: Int?) {
        guard let articlesData = data, let page = page else { return }
        
        var articleItems: [ArticleItem] = []
        
        for eachData in articlesData {
            guard let eachData = eachData as? [String: Any], let articleItem = ArticleItem.parseArticleItemData(eachData) else { return }
            
            articleItems.append(articleItem)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.AllArticlesDataObserver.rawValue), object: nil, userInfo: ["page":page, "items":articleItems])
        
    }
    
    func parseAllVideosData(data: [Any]?, page: Int?) {
        guard let videosData = data, let page = page else { return }
        var videoItems: [VideoItem] = []
        
        for eachData in videosData {
            guard let eachData = eachData as? [String: Any], let videoItem = VideoItem.parseVideoItemData(eachData) else { return }
            
            videoItems.append(videoItem)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.AllVideosDataObserver.rawValue), object: nil, userInfo: ["page":page, "items":videoItems])
        
    }
    
    
    
    func parseMediaByGenreData(data: [Any]?, page: Int?, type: String?) {
        guard let mediaByGenreData = data, let page = page, let type = type else { return }
        var mediaList: [EscapeItem] = []
        
        for eachEscapeData in mediaByGenreData {
            
            guard let eachEscapeData = eachEscapeData as? [String: Any], let id = eachEscapeData["id"] as? String, let name = eachEscapeData["name"] as? String, let escapeType = eachEscapeData["escape_type"] as? String else {
                continue
            }
            
            let escapeItem = EscapeItem.addOrEditEscapeItem(id, name: name, escapeType: escapeType, posterImage: eachEscapeData["poster_image"] as? String, year: eachEscapeData["year"] as? String, rating: eachEscapeData["rating"] as? NSNumber, subTitle: eachEscapeData["subtitle"] as? String, createdBy: eachEscapeData["creator"] as? String, _realm: nil, nextAirtime: eachEscapeData["next_airtime"] as? [String:Any])
            
            if let isTracking = eachEscapeData["is_tracking"] as? Bool {
                escapeItem.isTracking = isTracking
            }
            if let hasActed = eachEscapeData["is_acted"] as? Bool {
                escapeItem.hasActed = hasActed
            }
            mediaList.append(escapeItem)
            
        }
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.MediaByGenreDataObserver.rawValue), object: nil, userInfo: ["page":page, "items":mediaList, "type": type])
    }
    
    func parseHomeDiscoverItemData(discoverItemData: [String:AnyObject]?, page: Int?) {
        guard let discoverItemData = discoverItemData, let page = page else {
            return
        }
        
        if let homeItem = HomeItem.createHomeItem(homeData: discoverItemData) {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationObservers.HomeItemDataObserver.rawValue), object: nil, userInfo: ["page":page, "item":homeItem])
        }
        
    }
    
    func parseHomeData(homeData: [Any], page: Int?) {
        
        var homeItems:[HomeItem] = []
        for eachItem in homeData {
            if let homeData = eachItem as? [String:Any], let homeItem = HomeItem.createHomeItem(homeData: homeData) {
                homeItems.append(homeItem)
            }
        }
        
        if let homeDataDelegate = self.homeDataDelegate {
            homeDataDelegate.didReceiveHomeData(data: homeItems, page: page)
        }
    }
    
    //MARK: - Error Fetching
    
    func errorFetchingHome() {
        if let homeDataDelegate = self.homeDataDelegate {
            homeDataDelegate.errorRecievingHomeData()
        }
    }
}
