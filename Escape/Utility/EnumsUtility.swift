//
//  EnumsUtility.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

enum ScreenManagerAction : String {
    case MainTab = "MainTab"
    case HomeTab = "Home"
    case DiscoverTab = "Discover"
    case MyAccountTab = "MyAccount"
    case MyAccountSetting = "MyAccountSetting"
    case OpenItemDescription = "item"
    case OpenFollowers = "OpenFollowers"
    case OpenAddToEscapePopUp = "OpenAddToEscapePopUp"
    case OpenUserAccount = "user"
    case NoNetworkPresent = "NoNetworkPresent"
    case NetworkPresent = "NetworkPresent"
    case OpenSearchView = "openSearchView"
    case OpenUserEscapesList = "UserEscapeList"
    case OpenFriendsView = "OpenFriendsView"
    case OpenSingleStoryView = "story"
}

enum StoryBoardIdentifier : String{
    case Onboarding = "Onboarding"
    case MainTab = "MainTab"
    case MyAccount = "MyAccount"
    case Discover = "Discover"
    case Home = "Home"
    case Notifications = "Notifications"
    case Search = "Search"
    case AddToEscape = "AddToEscape"
    case GenericLists = "GenericLists"
}
enum LoginTypeEnum : String {
    case Facebook = "fb"
    case Email    = "email"
}
enum Gender : Int{
    case male = 1
    case female = 2
}

enum ProfileItemType: Int {
    case showLoading = -1
    case escapeList = 0
    case maybeSeen = 1
}

enum ProfileListType: String {
    case Activity = "activity"
    case Movie = "movie"
    case TvShows = "tv_show"
    case Books = "book"
}

enum EscapeType: String {
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

enum EscapeCreatorType : String{
    case Movie = "Director"
    case TvShows = "Creator"
    case Books = "Author"
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
    case activity = 1
    case movie = 2
    case tvShows = 3
    case books = 4
}
enum UserType : Int{
    case followers = 1
    case following = 2
    case friends   = 3
    case fbFriends = 4
    case sharedUsersOfStory = 5
}

enum EscapeAddActions: String {
    case Watched = "Watched"
    case ToWatch = "To Watch"
    case Watching = "Currently Watching"
    case Read = "Read"
    case ToRead = "To Read"
    case Reading = "Currently Reading"
}

enum NotificationObservers: String {
    case MyAccountObserver = "MyAccountObserver"
    case DiscoverObserver = "DiscoverObserver"
    case SearchObserver = "SearchObserver"
    case SearchQueryObserver = "SearchQueryObserver"
    case GetProfileDetailsObserver = "GetProfileDetailsObserver"
    case OtherUserProfileListFetchObserver = "OtherUserProfileListFetchObserver" 
    case HomeTappedObserver =  "HomeTappedObserver" 
}
enum StoryType : NSNumber {
    case emptyStory = -1
    case whatsYourEscape = -2
    case suggestedFollows = 0
    case addToEscape = 1
    case recommeded = 2
    case article = 3
    case fbFriendFollow = 4
}
enum CreatorType : NSNumber{
    case user =     0
    case escape =   1
    case article =  2
}
enum OptionsType : String{
    case Edit = "Edit"
    case Delete = "Delete"
    case Recommend = "Recommend to friend"
    case Add = "Add to your escape"
}
