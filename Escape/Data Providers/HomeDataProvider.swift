//
//  HomeDataProvider.swift
//  Escape
//
//  Created by Ankit on 04/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol HomeDataProtocol : class {
    func recievedStories(data : [BaseStory])
    func error()
}
protocol HomeStoryCommentProtocol : class {
    func recievedStoryComment(comments : [StoryComment] , storyId : String)
    func error()
    func postStoryCommentSuccess()
    func errorPostComment()
}
protocol SingleStoryProtocol : class{
    func recievedStory(story : BaseStory)
    func error()
}

class HomeDataProvider: CommonDataProvider {
    
    weak var homeDataDelegate : HomeDataProtocol?
    weak var storyCommentDelegate : HomeStoryCommentProtocol?
    weak var singleStoryDelegate : SingleStoryProtocol?
    
    static let sharedDataProvider = HomeDataProvider()
    
    func getUserStroies(page : Int){
        
        var params : [String:AnyObject] = [:]
        params["page"] = page
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserStory, params: params, delegate: self)
    }
    
    func getStoryComments(storyId : String){
        var params : [String:AnyObject] = [:]
        params["story_id"] = storyId
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetStoryComment, params: params, delegate: self)
        
    }
    
    func postStoryComments(storyId : String,comment : String){
        var params : [String:AnyObject] = [:]
        params["story_id"] = storyId
        params["comment"] = comment
        
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .PostStoryComment, params: params, delegate: self)
        
    }
    
    func likeStory(isLike : Bool, storyId : String){
        if isLike{
            ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .LikeStory, params: ["story_id" : storyId], delegate: self)
        }else{
            ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .UnlikeStroy, params:  ["story_id" : storyId], delegate: self)
        }
    }
    
    func shareStory(isShare : Bool, storyId : String){
        if isShare{
            ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .ShareStory, params: ["story_id" : storyId], delegate: self)
        }else{
            ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .UnShareStory, params:  ["story_id" : storyId], delegate: self)
        }
    }
    
    func getSingleStrory(storyId : String){
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetSingleStory, params:  ["story_id" : storyId], delegate: self)
    }
    
    func followAllFriends(storyId : String){
        ServiceCall(.POST, serviceType: .ServiceTypePrivateApi, subServiceType: .FollowAllFriends, params:  ["story_id" : storyId], delegate: self)
    }
    
    
    override func serviceSuccessfull(service: Service) {
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
    
    override func serviceError(service: Service) {
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
    func parseUserStories(data : [AnyObject]?){
        
        var storyData : [BaseStory] = []
       
        if let storyDataArray = data as? [[String:AnyObject]]{
            for dataDict in storyDataArray{
                if let storyType = dataDict["story_type"] as? NSNumber,
                    let storyCardType = StoryType(rawValue: storyType) {
                    
                    switch storyCardType {
                        
                    case .FBFriendFollow:
                        storyData.append(FBFriendCard(dict: dataDict))
                        break
                    
                    case .AddToEscape:
                        storyData.append(AddToEscapeCard(dict: dataDict))
                        break
                        
                    case .Recommeded:
                        storyData.append(AddToEscapeCard(dict: dataDict))
                        break
                        
                    case .Article:
                        storyData.append(ArticleCard(dict: dataDict))
                        break
                        
                    case .EmptyStory:
                        break
                        
                    case .WhatsYourEscape:
                        break
                        
                    case .SuggestedFollows:
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
    
    
    func parseStoryComment(data : [AnyObject], storyId : String){
        
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
    
    func parseSingleStory(dict : [String:AnyObject]){
        
        var storyData : BaseStory?
        
        if let storyType = dict["story_type"] as? NSNumber,
            let storyCardType = StoryType(rawValue: storyType) {
            
            switch storyCardType {
                
            case .FBFriendFollow:
                storyData = FBFriendCard(dict: dict)
                break
                
            case .AddToEscape:
                storyData = AddToEscapeCard(dict: dict)
                break
                
            case .Recommeded:
                storyData = AddToEscapeCard(dict: dict)
                break
                
            case .Article:
                storyData = ArticleCard(dict: dict)
                break
                
            case .EmptyStory:
                break
                
            case .WhatsYourEscape:
                break
                
            case .SuggestedFollows:
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
