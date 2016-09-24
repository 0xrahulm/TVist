//
//  EnumsUtility.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

enum ScreenManagerAction : String{
    
    case MainTab = "MainTab"
    case HomeTab = "Home"
    case DiscoverTab = "Discover"
    case MyAccountTab = "MyAccount"
    case MyAccountSetting = "MyAccountSetting"
    case OpenItemDescription = "OpenItemDescription"
    case OpenFollowers = "OpenFollowers"
    case OpenAddToEscapePopUp = "OpenAddToEscapePopUp"
    case OpenUserAccount = "OpenUserAccount"
    case NoNetworkPresent = "NoNetworkPresent"
    case NetworkPresent = "NetworkPresent"
    case OpenSearchView = "openSearchView"
    
}
enum StoryBoardIdentifier : String{
    case Onboarding = "Onboarding"
    case MainTab = "MainTab"
    case MyAccount = "MyAccount"
    case Search = "Search"
}
enum LoginTypeEnum : String {
    case Facebook = "fb"
    case Email    = "email"
}
enum Gender : Int{
    case Male = 1
    case Female = 2
}
enum EscapeType : String{
    case Activity = "activity"
    case Movie = "movie"
    case TvShows = "tv_show"
    case Books = "book"
}
enum DiscoverType : String{
    case All = "all"
    case People = "people"
    case Movie = "movie"
    case TvShows = "tv_show"
    case Books = "book"
}
enum SearchType : String{
    case All = "all"
    case User = "user"
    case Movie = "movie"
    case TvShows = "tv_show"
    case Books = "book"
    case Blank = "blank"
}
enum Tap : Int{
    case Activity = 1
    case Movie = 2
    case TvShows = 3
    case Books = 4
}
enum UserType : Int{
    case Followers = 1
    case Following = 2
    case Friends   = 3
}
enum EscapeAddActions : String{
    case Watched = "Watched"
    case ToWatch = "To Watch"
    case Watching = "Currently Watching"
    case Read = "Read"
    case ToRead = "To Read"
    case Reading = "Currently Reading"
}
enum NotificationObservers : String{
    case MyAccountObserver = "MyAccountObserver"
    case DiscoverObserver = "DiscoverObserver"
    case SearchObserver = "SearchObserver"
    case SearchQueryObserver = "SearchQueryObserver"
}
enum StoryType : NSNumber {
    case EmptyStory = -1
    case FBFriendFollow = 0
    case AddToEscape = 1
    case Recommeded = 2
}
enum CreatorType : NSNumber{
    case User =     0
    case Escape =   1
}
enum OptionsType : String{
    case Edit = "Edit"
    case Delete = "Delete"
    case Recommend = "Recommend to friend"
    case Add = "Add to your escape"
}
