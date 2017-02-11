//
//  NetworkConstants.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum ServiceType : String {
    //case ServiceTypePrivateApi="http://api.escape-app.com/api/"
    case ServiceTypePrivateApi="http://172.16.1.195:3000/api/"
}
enum SubServiceType : String {

    //Sign in
    case GetUsers       = "users/"
    case FBSignIn       = "signin_with_facebook"
    case EmailSignUp    = "register_with_email"
    case EmailSigIn     = "login_with_email"
    case FetchInterests = "fetch_all_interests"
    case PostInterests  = "user_interests"
    
    // My Account
    case GetUserDetails =  "get_user_details"
    case GetProfileList =  "profile/list"
    case GetUserEscapes =  "user/escapes"
    case LogoutUser     =  "logout"
    case GetItemDesc    =  "escapes/detail"
    case GetFollowers   =  "get_user_followers"
    case GetFollowing   =  "get_user_following"
    case GetFriends     =  "get_user_friends"
    case AddEscapes     =  "add_escape"
    case FollowUser     =  "follow_user"
    case UnfollowUser   =  "unfollow_user"
    case PostRecommend  =  "users/recommendation"
    
    //Discover
    case GetDiscoverItems = "lets_discover"
    
    //Home
    case GetUserStory       =  "get_user_stories"
    case GetStoryComment    =  "story/comments"
    case PostStoryComment   =  "story/comment"
    case LikeStory          =  "stories/like"
    case UnlikeStroy        =  "stories/unlike"
    case ShareStory         =  "stories/share"
    case UnShareStory       =  "stories/unshare"
    case GetSingleStory     =  "stories/details"
    case GetLinkedObjects   =  "stories/linked_objects"
    case FollowAllFriends   =  "stories/follow_all"
    case GetSharedUsersOfStory = "stories/shared_by"
    
    
    //Search
    case GetSearchItems = "search"
    
    //Notification
    case GetNotification = "user/notifications"
    
    
    
    
}

class NetworkConstants: NSObject {
    
    

}
