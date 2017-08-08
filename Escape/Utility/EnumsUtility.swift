//
//  EnumsUtility.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

enum ScreenManagerAction : String {
    case ListingsTab = "ListingsTab"
    case GuideTab = "GuideTab"
    case TrackerTab = "TrackerTab"
    case TopChartsTab = "TopChartsTab"
    case SearchTab = "SearchTab"
    case WatchlistTab = "WatchlistTab"
    case MainTab = "MainTab"
    case MyAccountSetting = "MyAccountSetting"
    case OpenItemDescription = "item"
    case OpenFollowers = "OpenFollowers"
    case OpenAddToEscapePopUp = "OpenAddToEscapePopUp"
    case OpenEditEscapePopUp = "OpenEditEscapePopUp"
    case OpenUserAccount = "user"
    case NoNetworkPresent = "NoNetworkPresent"
    case NetworkPresent = "NetworkPresent"
    case OpenSearchView = "openSearchView"
    case OpenUserEscapesList = "UserEscapeList"
    case OpenFriendsView = "OpenFriendsView"
    case OpenSingleStoryView = "story"
    case OpenSimilarEscapesView = "OpenSimilarEscapesView"
    case OpenRelatedPeopleView = "OpenRelatedPeopleView"
    case OpenNotificationView = "openNotificationView"
    case OpenSignupView = "openSignupView"
    case OpenGuideListView = "OpenGuideListView"
    case OpenListingItemView = "OpenListingItemView"
    case OpenMediaOptionsView = "OpenMediaOptionsView"
    case OpenFullListingsView = "OpenFullListingsView"
    case OpenChannelListingView = "OpenChannelListingView"
}

enum StoryBoardIdentifier : String{
    case Onboarding = "Onboarding"
    case Watchlist = "Watchlist"
    case MainTab = "MainTab"
    case MyAccount = "MyAccount"
    case Listings = "Listings"
    case TvGuide = "TvGuide"
    case Home = "Home"
    case Notifications = "Notifications"
    case Tracker = "Tracker"
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
    case userStory = 2
    case showDiscoverNow = 3
}

enum ProfileListType: String {
    case Activity = "activity"
    case Movie = "movie"
    case TvShows = "tv_show"
    case Books = "book"
}

enum GuideListType:String {
    case All="all"
    case Television="tv_show"
    case Movie="movie"
}


enum GuideItemType: Int {
    case showLoading = -1
    case escapeList = 0
    case maybeSeen = 1
    case userStory = 2
    case showDiscoverNow = 3
}

enum ListingItemType: Int {
    case showLoading = -1
    case listingDays = 0
    case mediaList = 1
    case pickChannel = 2
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
    case Story = "story"
}

enum EscapeCreatorType : String{
    case Movie = "Directed by"
    case TvShows = "Created by"
    case Books = "Authored by"
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
    case Watching = "Tracking"
    case Read = "Read"
    case ToRead = "To Read"
    case Reading = "Reading"
}

enum NotificationObservers: String {
    case MyAccountObserver = "MyAccountObserver"
    case DiscoverObserver = "DiscoverObserver"
    case SearchObserver = "SearchObserver"
    case SearchQueryObserver = "SearchQueryObserver"
    case GetProfileDetailsObserver = "GetProfileDetailsObserver"
    case OtherUserProfileListFetchObserver = "OtherUserProfileListFetchObserver" 
    case HomeClickObserver =  "HomeClickObserver"
    case TvGuideDataObserver = "TvGuideDataObserver"
    case TvGuideItemDataObserver = "kGuideItemDataNotification"
    case ListingItemObserver = "kListingItemDataNotification"
    case ListingsDataObserver = "ListingsDataObserver"
    case FullListingsDataObserver = "FullListingsDataObserver"
    case ListingsChannelDataObserver = "ListingsChannelDataObserver"
    case ListingMediaItemsObserver = "ListingsMediaItemsObserver"
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

enum EventName:String {
    case DeviceSessionBeginGenerating = "Device_Session_Begin_Generating"
    // Listings
    case ListingsPageLoaded = "Listings_Page_Loaded"
    
    case ListingsDateTodayClick = "Listings_Date_Today_Click"
    case ListingsDateTomorrowClick = "Listings_Date_Tomorrow_Click"
    case ListingsDateWeekendClick = "Listings_Date_Weekend_Click"
    
    case ListingsShowsClick = "Listings_Show_Click"
    case ListingsShowsViewAllClick = "Listings_Shows_View_All_Click"
    case ListingsViewAllPageItemClick = "Listings_View_All_Page_Item_Click"
    case ListingsAllChannelsClick = "Listings_All_Channels_Click"
    case ListingsChannelCategoryClick = "Listings_Channel_Category_Click"
    case ListingsPickChannel = "Listings_Pick_Channel"
    case ListingsChannelItemClick = "Listings_Channel_Item_Click"
    case ListingsChannelViewAllClick = "Listings_Channel_View_All_Click"
    
    case FullListingsDateClick = "Full_Listings_Date_Click"
    case FullListingsCategoryDropdownClick = "Full_Listings_Category_Dropdown_Click"
    case FullListingsChannelDropdownClick = "Full_Listings_Channel_Dropdown_Click"
    
    case FullListingsCategorySelected = "Full_Listings_Category_Selected"
    case FullListingsChannelSelected = "Full_Listings_Channel_Selected"
    case FullListingsSectionViewAllClick = "Full_Listings_View_All_Click"
    case FullListingsItemClick = "Full_Listings_Item_Click"
    case ChannelListingPageOpened = "Channel_Listing_Page_Opened"
    case ChannelListingItemClick = "Channel_Listing_Item_Click"
    
    case onboardingScreen = "Onboarding_Screen"
    case continueWithFB = "Conitnue_With_Facebook_Click"
    case continueWithEmail = "Continue_With_Email_Click"
    case facebookLoginFailure = "Facebook_Login_Failure"
    case emailLoginErrorPopup = "Error_Popup_Shown"
    case signInTabClick = "Sign_In_Tab_Click"
    case signUpTabClick = "Sign_Up_Tab_Click"
    case doneButtonOnEmailLogin = "Done_Button_On_Email_Login"
    case doneButtonOnEmailSignup = "Done_Button_On_Email_Signup"
    case interestsSelected = "Interests_Selection_Done"
    
    case SearchOnDiscoverClick = "Search_On_Discover_Click"
    
    case AddToEscapeOpened = "Add_To_Escape_Opened"
    case AddToEscapeDone = "Add_To_Escape_Done"
    case ShareWithFriendsClick = "Share_With_Friends_Click"
    
    case UserProfileOpened = "User_Profile_Opened"
    case emptyStateWhatsappClick = "Empty_State_Whatsapp_Click"
    case emptyStateiMessageClick = "Empty_State_iMessage_Click"
    case emptyStateMessengerClick = "Empty_State_Messenger_Click"
    case emptyStateSearchClick = "Empty_State_Search_Click"
    case emptyStateDiscoverClick = "Empty_State_Discover_Click"
    
    //TV guide
    case GuideDataLoaded = "Guide_Data_Loaded"
    case GuideSegmentClick = "Guide_Segment_Click"
    case TrackButtonClick = "Added_To_Tracker"
    case UndoTrack = "Undo_Track"
    case GuideScreenScroll = "Guide_Screen_Scroll"
    
    case SearchClick = "Search_Click"
    case SearchCancelled = "Search_Cancelled"
    case TrackerSegmentClick = "Tracker_Segment_Click"
    case WatchlistSegmentClick = "Watchlist_Segment_Click"
    case SearchOccurred = "Item_Searched"
    case ItemsShown = "Items_Shown"
    case SearchItemClick = "Search_Item_Click"
    case TrackSearchedItem = "Track_Searched_Item"
    case OpenedDescriptionSearchedItem = "Opened_Description_Searched_Item"
    case SearchInvalid = "Search_Invalid"
    case GuideItemClick = "Guide_Item_Click"
    
    case GuideViewAllClick = "Guide_View_All_Click"
    
    case ItemDescriptionOpened = "Item_Description_Opened"
    
    
    case TrackerTabClick = "Tracker_Tab_Click"
    case OpenTrackedItem = "Open_Tracked_Item"
    case ListingsTabClick = "Listings_Tab_Click"
    
    case GuideTabClick = "Guide_Tab_Click"
    case SearchTabClick = "Search_Tab_Click"
    case WatchlistTabClick = "Watchlist_Tab_Click"
    case SignUpNowClick = "SignUp_Now_Click"
    
    case ViewAllSeen = "ViewAll_Seen"
    
    case ViewAllWatchlist = "ViewAll_Watchlist"
    case TopCharts_Segment_Click = "TopCharts_Segment_Click"
    case TopCharts_Item_Click = "TopCharts_Item_Click"
    
    case AddedToSeen = "Added_To_Seen"
    case AddedToWatchlist = "Added_To_Watchlist"
    
    case UndoSeen = "Undo_Seen"
    case UndoWatchlist = "Undo_Watchlist"
    
    case OpenWatchlistedItem = "Open_Watchlisted_Item"
    
    //Details Page
    
    case DetailsPageSegmentClick = "Details_Page_Segment_Click"
    
    case SeeAirtimesClick = "Item_AirTime"
    case SeeImdbDetailsClick = "IMDb_Details"
    
    
    case ViewingOptionsClick = "Viewing_Options_Click"
    case MediaViewOptionsListOpen = "Viewing_Options_List_Page_Open"
    case ViewingOptionSelected = "Viewing_Option_Selected"
    
    case SimilarShowsViewAllClick = "Similar_Shows_View_All_Click"
    case SimilarShowsItemClick = "Similar_Shows_Item_Click"
    
    case NotificationPermissionProvided = "Notification_Permission_Provided"
    
    case AllAirtimesClick = "All_Airtimes_Click"
    
}
