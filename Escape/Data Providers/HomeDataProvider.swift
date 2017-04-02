//
//  HomeDataProvider.swift
//  Escape
//
//  Created by Ankit on 04/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol HomeDataProtocol : class {
    func recievedStories(_ data : [BaseStory])
    func error()
}
protocol HomeStoryCommentProtocol : class {
    func recievedStoryComment(_ comments : [StoryComment] , storyId : String)
    func error()
    func postStoryCommentSuccess()
    func errorPostComment()
}
protocol SingleStoryProtocol : class{
    func recievedStory(_ story : BaseStory)
    func error()
}

class HomeDataProvider: CommonDataProvider {
    
    weak var homeDataDelegate : HomeDataProtocol?
    weak var storyCommentDelegate : HomeStoryCommentProtocol?
    weak var singleStoryDelegate : SingleStoryProtocol?
    
    static let sharedDataProvider = HomeDataProvider()
    
    func getUserStroies(_ page : Int){
        
        var params : [String:Any] = [:]
        params["page"] = page
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserStory, params: params, delegate: self)
    }
    
    func getStoryComments(_ storyId : String){
        var params : [String:Any] = [:]
        params["story_id"] = storyId
        
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetStoryComment, params: params, delegate: self)
        
    }
    
    func postStoryComments(_ storyId : String,comment : String){
        var params : [String:Any] = [:]
        params["story_id"] = storyId
        params["comment"] = comment
        
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .PostStoryComment, params: params, delegate: self)
        
    }
    
    func likeStory(_ isLike : Bool, storyId : String){
        if isLike{
            ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .LikeStory, params: ["story_id" : storyId], delegate: self)
        }else{
            ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UnlikeStroy, params:  ["story_id" : storyId], delegate: self)
        }
    }
    
    func shareStory(_ isShare : Bool, storyId : String){
        if isShare{
            ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .ShareStory, params: ["story_id" : storyId], delegate: self)
        }else{
            ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .UnShareStory, params:  ["story_id" : storyId], delegate: self)
        }
    }
    
    func getSingleStrory(_ storyId : String){
        ServiceCall(.get, serviceType: .ServiceTypePrivateApi, subServiceType: .GetSingleStory, params:  ["story_id" : storyId], delegate: self)
    }
    
    func followAllFriends(_ storyId : String){
        ServiceCall(.post, serviceType: .ServiceTypePrivateApi, subServiceType: .FollowAllFriends, params:  ["story_id" : storyId], delegate: self)
    }
    
    
    override func serviceSuccessfull(_ service: Service) {
        if let subServiceType = service.subServiveType{
            
            let params = service.parameters 
            
            switch subServiceType {
                
            case .GetUserStory:
                if let data = service.outPutResponse as? [AnyObject]{
                    self.parseUserStories(data)
                }
                break
                
            case .GetStoryComment:
                if let data = service.outPutResponse as? [AnyObject]{
                    if let params = params, let storyId = params["story_id"] as? String{
                        self.parseStoryComment(data,storyId: storyId)
                    }
                }
                break
                
            case .PostStoryComment:
                if let delegate = storyCommentDelegate{
                    delegate.postStoryCommentSuccess()
                }
                break
                
            case .LikeStory:
                print("Story Liked")
                break
            case .UnlikeStroy:
                print("Story UnLiked")
                break
            case .ShareStory:
                print("Story Shared")
                break
            case .UnShareStory:
                print("Story UnShared")
                break
            case .GetSingleStory:
                if let data = service.outPutResponse as? [String:AnyObject]{
                    self.parseSingleStory(data)
                }
                break
            case .FollowAllFriends:
                print("All Friends Followed")
                break
                
            default:
                break
            }
        }
    }
    
    override func serviceError(_ service: Service) {
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
                
            case .GetUserStory:
                if homeDataDelegate != nil{
                    homeDataDelegate?.error()
                }
                break
                
            case .GetStoryComment:
                if let delegate = storyCommentDelegate{
                    delegate.error()
                }
                break
                
            case .PostStoryComment:
                if let delegate = storyCommentDelegate{
                    delegate.errorPostComment()
                }
                break
                
            case .LikeStory:
                print("Story Liked Error")
                break
            case .UnlikeStroy:
                print("Story UnLiked Error")
                break
            case .ShareStory:
                print("Story Shared Error")
                break
            case .UnShareStory:
                print("Story UnShared Error")
                break
            case .GetSingleStory:
                if let delegate = singleStoryDelegate{
                    delegate.error()
                }
                break
            case .FollowAllFriends:
                print("All Friends Followed Error")
                break
                
                
            default:
                break
            }
        }
    }
}
// MARK :- Parsing

extension HomeDataProvider {
    func parseUserStories(_ data : [AnyObject]?){
        
        var storyData : [BaseStory] = []
       
        if let storyDataArray = data as? [[String:AnyObject]]{
            for dataDict in storyDataArray{
                if let storyType = dataDict["story_type"] as? NSNumber,
                    let storyCardType = StoryType(rawValue: storyType) {
                    
                    switch storyCardType {
                        
                    case .fbFriendFollow:
                        storyData.append(FBFriendCard(dict: dataDict))
                        break
                    
                    case .addToEscape:
                        storyData.append(AddToEscapeCard(dict: dataDict))
                        break
                        
                    case .recommeded:
                        storyData.append(AddToEscapeCard(dict: dataDict))
                        break
                        
                    case .article:
                        storyData.append(ArticleCard(dict: dataDict))
                        break
                        
                    case .emptyStory:
                        break
                        
                    case .whatsYourEscape:
                        break
                        
                    case .suggestedFollows:
                        storyData.append(SuggestedFollowsCard(dict: dataDict))
                        break
                       
                        // Also make changes in single story function
                    }
                }
            }
            
            if homeDataDelegate != nil{
                homeDataDelegate?.recievedStories(storyData)
            }
            
        }else{
            print("Empty Stories")
        }
    }
    
    
    func parseStoryComment(_ data : [AnyObject], storyId : String){
        
        let comments = StoryComment(commentArray: data).comments
        
        if comments.count > 0{
            if let delegate = storyCommentDelegate{
                delegate.recievedStoryComment(comments, storyId: storyId)
            }
        }else{
            if let delegate = storyCommentDelegate{
                delegate.error()
            }

        }
        
    }
    
    func parseSingleStory(_ dict : [String:AnyObject]){
        
        var storyData : BaseStory?
        
        if let storyType = dict["story_type"] as? NSNumber,
            let storyCardType = StoryType(rawValue: storyType) {
            
            switch storyCardType {
                
            case .fbFriendFollow:
                storyData = FBFriendCard(dict: dict)
                break
                
            case .addToEscape:
                storyData = AddToEscapeCard(dict: dict)
                break
                
            case .recommeded:
                storyData = AddToEscapeCard(dict: dict)
                break
                
            case .article:
                storyData = ArticleCard(dict: dict)
                break
                
            case .emptyStory:
                break
                
            case .whatsYourEscape:
                break
                
            case .suggestedFollows:
                storyData = SuggestedFollowsCard(dict: dict)
                break
                
                 // Also make changes in get stories function
                
            }
        }
        
        if let delegate = singleStoryDelegate{
            if let storyData = storyData{
                delegate.recievedStory(storyData)
            }else{
                delegate.error()
            }
            
        }
        
    }
}
