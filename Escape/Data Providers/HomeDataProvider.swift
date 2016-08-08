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

class HomeDataProvider: CommonDataProvider {
    
    weak var homeDataDelegate : HomeDataProtocol?
    
    static let sharedDataProvider = HomeDataProvider()
    
    func getUserStroies(){
        
        //var params : [String:AnyObject] = [:]
        
        ServiceCall(.GET, serviceType: .ServiceTypePrivateApi, subServiceType: .GetUserStory, params: nil, delegate: self)
    }
    
    override func serviceSuccessfull(service: Service) {
        if let subServiceType = service.subServiveType{
            
            switch subServiceType {
                
            case .GetUserStory:
                if let data = service.outPutResponse as? [AnyObject]{
                    self.parseUserStories(data)
                }
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
                        
                    case .EmptyStory:
                        break
                        
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
}
