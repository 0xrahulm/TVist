//
//  NetworkConstants.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum ServiceType : String {
    case ServiceTypePrivateApi="https://api.mizzleapp.com/api/"
//    case ServiceTypePrivateApi="https://750cec43.ngrok.io/api/"
    
}

enum SubServiceType : String {

    // Session
    case DeviceSession   = "device_session"
    //Sign in
    case GetUsers       = "users/"
    case FBSignIn       = "signin_with_facebook"
    case EmailSignUp    = "register_with_email"
    case EmailSigIn     = "login_with_email"
    case FetchInterests = "fetch_all_interests"
    case PostInterests  = "user_interests"
    
    // My Account
    case GetUserDetails     =  "get_user_details"
    
    case verifyReceipt      =  "checkout/verify_receipt"
    case GetProfileList     =  "profile/list"
    case GetEscapeAction    =  "user/escapes/action"
    case GetUserEscapes     =  "user/escapes"
    case PutProfilePicture  =  "user/picture"
    case DeleteEscape       =  "user/escapes/remove"
    case UpdateEscape       =  "user/escapes/update"
    case LogoutUser         =  "logout"
    case GetItemDesc        =  "escapes/detail"
    case GetSimilarEscape   =  "escapes/similar"
    case GetRelatedPeople   =  "escapes/people"
    case GetFollowers       =  "get_user_followers"
    case GetFollowing       =  "get_user_following"
    case GetFriends         =  "get_user_friends"
    case AddEscapes         =  "add_escape"
    case FollowUser         =  "follow_user"
    case UnfollowUser       =  "unfollow_user"
    case PostRecommend      =  "users/recommendation"
    case UpdatePushToken    =  "users/push_token_update"
    
    //Discover
    case GetDiscoverItems = "lets_discover"
    
    
    //TV Guide
    case GetGuideList     =  "guide/list"
    case GetGuideItem     =  "guide/item"
    case GetViewingOptions = "escapes/viewing_options"
    case GetAirtimes        = "escapes/airtime"
    
    //Home
    
    case HomeData = "home"
    case TodayIndex = "home/today"
    case Next7DaysIndex = "home/next_7_days"
    case DiscoverIndex = "home/discover_index"
    case HomeDiscoverItem = "home/discover"
    case MediaByGenre = "escapes/by_genre"
    case HomeAllArticles = "home/all_articles"
    case HomeAllGenres = "home/all_genres"
    case HomeAllVideos = "home/all_videos"
    case HomeRemoveSection = "home/remove_section"
    
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
    case GetSearchItems = "search_v3"
    case GetSearchItemsNoAuth = "search/no_auth"
    
    //Notification
    case GetNotification = "user/notifications"
    
    //Watchlist
    case UserWatchlist = "user/watchlist"
    
    //Tracking
    case UserTrackings = "user/trackings"
    case RemoveUserTracking = "user/trackings/remove"
    
    case Listings = "listings"
    case ListingsItem = "listings/item"
    case CategoryChannels = "category/channels"
    case ChannelListings = "channels/listing"
    case ListingCategories = "categories"
    case FullListings = "full_listings"
    
    
    case RemoteAiringNow = "remote/airing_now"
    case RemoteCategories = "remote/categories"
    
    case RemoteLogs = "remote/log"
    case RemoteParseDevice = "remote/get_data"
    case RemoteSaveDevice = "remote/save_data"
    
    
    case PostAlertPreference = "preferences/alert_preference"
    case PostNewEpisodesPreference = "preferences/new_episodes_preference"
    case PostAlertBeforeAirtimePreference = "preferences/alert_before_airtime"
    
    case PostAirtimePreference = "preferences/airtime_preference"
    case PostAirdatePreference = "preferences/airdate_preference"
    
    case PostTimeZonePreference = "preferences/time_zone_preference"
    case PostChannelsPreference = "preferences/channels_preference"
    case PostAlertFrequency = "preferences/alert_frequency"
    
}

class NetworkConstants: NSObject {
    
    

}
