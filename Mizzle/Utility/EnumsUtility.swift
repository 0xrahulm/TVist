//
//  EnumsUtility.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

enum ScreenManagerAction: String {
    case ListingsTab = "ListingsTab"
    case HomeTab = "HomeTab"
    case TrackerTab = "TrackerTab"
    case TopChartsTab = "TopChartsTab"
    case SearchTab = "SearchTab"
    case WatchlistTab = "WatchlistTab"
    case RemoteTab = "RemoteTab"
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
    case OpenHomeDiscoverItemView = "OpenHomeDiscoverItemView"
    case OpenBrowseByGenreView = "OpenBrowseByGenreView"
    case OpenAllGenreView = "OpenAllGenreView"
    case OpenAllVideosView = "OpenAllVideosView"
    case OpenRemoteConnectionPopup = "OpenRemoteConnectionPopup"
    case OpenAllArticlesView = "OpenAllArticlesView"
    case OpenDeviceSearchView = "OpenDeviceSearchView"
}

enum UniversalScreenManagerAction: String {
    case todayDetailView = "TodayDetailView"
    case next7DaysDetailView = "Next7DaysDetailView"
    case watchlistDetailView = "WatchlistDetailView"
    case seenDetailView = "SeenDetailView"
    case discoverDetailView = "DiscoverDetailView"
    case airingNowDetailView = "airingNowDetailView"
    case openUserView = "OpenUserView"
    case openSignUpView = "OpenSignUpView"
    case openTVistPremiumView = "OpenTVistPremiumView"
    case openProfileEditView = "OpenProfileEditView"
    case openGeneralSettingsView = "OpenGeneralSettingsView"
    case openAlertOptionsView = "OpenAlertOptionsView"
    case openLoginView = "openLoginView"
    case logOutUser = "LogOutUser"
    case openUserSettingsView = "OpenUserSettingsView"
    case restorePurchasesView = "RestorePurchasesView"
    case openTimeZoneSelectionView = "openTimeZoneSelectionView"
    case openAddToWatchlistView = "openAddToWatchlistView"
    case openMediaItemDescriptionView = "openMediaItemDescriptionView"
    case openHelpAndSupportView = "openHelpAndSupportView"
    case openSearchView = "openSearchView"
    case openHomeDiscoverItemView = "OpenHomeDiscoverItemView"
    case openBrowseByGenreView = "OpenBrowseByGenreView"
    case openAllGenreView = "OpenAllGenreView"
    case openPremiumPopupView = "openPremiumPopupView"
    case openSimilarEscapesView = "openSimilarEscapesView"
    case openUpdateDetailsInputView = "openUpdateDetailsInputView"
    case openAllAirtimesView = "openAllAirtimesView"
    case openChannelListingView = "openChannelListingView"
}

enum StoryBoardIdentifier : String{
    case Onboarding = "Onboarding"
    case UniversalApp = "UniversalApp"
    case Watchlist = "Watchlist"
    case MainTab = "MainTab"
    case MyAccount = "MyAccount"
    case Listings = "Listings"
    case TvGuide = "TvGuide"
    case Home = "Home"
    case Notifications = "Notifications"
    case Tracker = "Tracker"
    case Search = "NewSearch"
    case AddToEscape = "AddToEscape"
    case GenericLists = "GenericLists"
    case Remote = "Remote"
    case User = "User"
    case Settings = "Settings"
    case WhatsOn = "WhatsOn"
}

enum FeatureIdentifier: String {
    case airtimeAlerts
    case filters
    case sorting
    case channelFilters
    case advancedListing
}

enum TimeZoneIdentifier: String {
    case EasternTimeZone  = "e"
    case CentralTimeZone  = "c"
    case MountainTimeZone = "m"
    case PacificTimeZone  = "p"
}


enum UserPreferenceKey: String {
    case alertPreference = "alert_preference"
    case onlyNewEpisodes = "new_episodes"
    case alertBeforeAirtime = "alert_before_airtime"
    case alertFrequency = "alert_frequency"
    case airtimePreference = "airtime_preference"
    case airdatePreference = "airdate_preference"
    case timezonePreference = "time_zone_preference"
    case channelPreference = "channel_preference"
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

enum FilterType:String {
    case All="all"
    case Television="tv_show"
    case Movie="movie"
}

enum SupportTicketType: Int {
    case empty = -1
    case technical = 0
    case general = 1
    case howTo = 2
    case bugReport = 3
    case other = 4
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

enum HomeItemType: Int {
    case showLoading = -1
    case tracker = 0
    case listing = 1
    case discover = 2
    case articles = 3
    case videos = 4
    case genre = 5
    case remoteBanner=6
    case todayItem=7
    case next7DaysItem=8
    case channelList=9
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

enum SettingItemType {
    case premiumSetting
    case regular
    case onOffSetting
    case authButton
    case message
    case selectedOption
    case profilePicture
    case rangeSelection
}

enum SettingSections: String {
    case premium
    case account = "Account"
    case alerts = "Alerts"
    case support
    case authentication
}

enum SettingCellIdentifiers: String {
    case premiumCell = "PremiumTableViewCellIdentifier"
    case regularCell = "RegularTableViewCellIdentifier"
    case onOffCell = "OnOffTableViewCellIdentifier"
    case authCell = "AuthTableViewCellIdentifier"
    case messageCell = "MessageTableViewCellIdentifier"
    case singleSelectionCell = "SingleSelectionTableViewCellIdentifier"
    case selectedOptionCell = "SelectedOptionTableViewCellIdentifier"
    case rangeSelectionCell = "RangeSelectionTableViewCellIdentifier"
    case profilePictureCell = "ProfilePictureTableViewCellIdentifier"
}

enum SortType: String {
    case Recency = "Recency"
    case A_Z = "A-Z"
    case Z_A = "Z-A"
    case Airing = "Airing"
}

enum Tap : Int{
    case activity = 1
    case movie = 2
    case tvShows = 3
    case books = 4
}

enum UserType: String {
    case Guest = "g"
    case Registered = "r"
    case Premium = "p"
}



enum GenericDetailCellIdentifiers: String {
    case watchlistItemCell = "MediaWatchlistTableViewCell"
    case watchlistItemWithAirtime = "MediaWatchlistWithAirtimeTableViewCell"
    case mediaWatchlistSection = "MediaWatchlistSection"
    case mediaListCellIdentifier = "MediaListCell"
    case browseByGenreCell = "BrowseByGenreCell"
    case mediaListingCellIdentifier = "ListingTableViewCell"
    case articlesSectionTableViewCell = "ArticlesSectionTableViewCell"
    case videosSectionCell = "VideosSectionCell"
    case videosSectionCelliPad = "VideosSectionCelliPad"
    case remoteConnectBannerCell = "RemoteConnectBannerCell"
    case channelPlayWithAiringNowCell = "ChannelPlayWithAiringNowCell"
    case genericEscapeCell = "GenericEscapeCell"
    case channelWiseListCell = "ChannelWiseListCell"
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
    case HomeItemDataObserver = "HomeItemDataObserver"
    case MediaByGenreDataObserver = "MediaByGenreDataObserver"
    case AllArticlesDataObserver = "AllArticlesDataObserver"
    case AllVideosDataObserver = "AllVideosDataObserver"
    case RemoteDeviceParsedDataObserver = "RemoteDeviceParsedDataObserver"
    case UserDetailsDataObserver = "UserDetailsDataObserver"
    case CountsDidUpdateObserver = "CountsDidUpdateObserver"
    case ProfileImageChangesObserver = "ProfileImageChangesObserver"
}

enum EditableFieldType: String {
    case emailField
    case passwordField
    case firstNameField
    case lastNameField
}

enum UserPageItemType: Int {
    case listings = 0
    case today = 1
    case next7Days = 2
    case discover = 3
    case watchlist = 4
    case seen = 5
}

enum ScreenNames: String {
    case Listings = "Tv Listings"
    case Guide = "Guide"
    case FullListings = "Full Listings"
    case Tracker = "Tracker"
    case MediaDescription = "Media Description"
    case Watchlist = "Watchlist"
    case Search = "Search"
    case Home = "Home"
    case Remote = "Remote"
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

//enum EventName: String {
//    case DeviceSessionGenerated = "Device_Session_Generated"
//
//    // Tab Events
//    case HomeTabClick = "Home_Tab_Click"
//    case SearchTabClick = "Search_Tab_Click"
//    case WatchlistTabClick = "Watchlist_Tab_Click"
//
//    case TrackerTabClick = "Tracker_Tab_Click"
//    case RemoteTabClick = "Remote_Tab_Click"
//
//
//    // Home
//    case HomeSegmentClick = "Home_Segment_Click"
//    case HomeScreenScroll = "Home_Screen_Scroll"
//    case HomePageLoaded = "Home_Page_Loaded"
//    case HomeSectionHorizontalScroll = "Home_Section_Horizontal_Scroll"
//
//    case HomeWatchlistViewAllClick = "Home_Watchlist_View_All_Click"
//    case HomeWatchlistItemClick = "Home_Watchlist_Item_Click"
//    case HomeAiringNowPlayClick = "Home_Airing_Now_Play_Click"
//    case HomeAiringNowViewAllClick = "Home_Airing_Now_View_All_Click"
//    case HomeAiringNowItemClick = "Home_Airing_Now_Item_Click"
//
//    case HomeDiscoverViewAllClick = "Home_Discover_View_All_Click"
//    case HomeDiscoverScroll = "Home_Discover_Scroll"
//    case HomeDiscoverItemClick = "Home_Discover_Item_Click"
//
//    case HomeGenreViewAllClick = "Home_Genre_View_All_Click"
//    case HomeGenreItemClick = "Home_Genre_Item_Click"
//
//    case HomeArticlesItemClick = "Home_Articles_Item_Click"
//    case HomeArticlesViewAllClick = "Home_Articles_View_All_Click"
//    case HomeArticlesScroll = "Home_Articles_Scroll"
//
//    case HomeMajorVideoItemClick = "Home_Major_Video_Item_Click"
//    case HomeVideosItemClick = "Home_Videos_Item_Click"
//    case HomeVideosViewAllClick = "Home_Videos_View_All_Click"
//    case HomeSectionViewAllClick = "Home_Section_View_All_Click"
//
//    case AddedToTracker = "Added_To_Tracker"
//    case UndoTracker = "Undo_Track"
//
//    case HomeRemoteConnectButtonClick = "Home_Remote_Connect_Button_Click"
//    case HomeRemoteDoNotShowAgainClick = "Home_Remote_Do_Not_Show_Again_Click"
//
//    case HomeProfileImageHotspotClick = "Home_Profile_Button_Hotspot_Click"
//
//    // Home - Discover Page
//    case HomeDiscoverPageItemClick = "Home_Discover_Page_Item_Click"
//
//    // Home - Genre
//    case HomeAllGenresItemClick = "Home_All_Genres_Item_Click"
//    case HomeGenrePageSegmentClick = "Home_Genre_Page_Segment_Click"
//    case HomeGenrePageItemClick = "Home_Genre_Page_Item_Click"
//
//    // Home - Articles
//    case HomeAllArticlesItemClick = "Home_All_Articles_Item_Click"
//
//    // Home - Videos
//    case HomeAllVideosItemClick = "Home_All_Videos_Item_Click"
//
//    // Device Connect Events
//
//    case DeviceConnectPopupDismissed = "Device_Connect_Popup_Dismissed"
//    case DeviceConnectPopupDontHaveDirecTV = "Device_Connect_Popup_Not_A_DirecTV_Customer"
//    case DeviceConnectPopupSearchConnectedDevice = "Device_Connect_Popup_Search_Connected_Devices"
//
//    case DeviceSearchDirecTVDeviceFound = "Device_Search_DirecTV_Device_Found"
//    case DeviceSearchDirecTVDeviceShown = "Device_Search_DirecTV_Device_Shown"
//    case DeviceSearchDirecTVDeviceSelected = "Device_Search_DirecTV_Device_Selected"
//    case DeviceSearchNoDeviceFound = "Device_Search_No_Device_Found"
//    case DeviceSearchRetryButtonClick = "Device_Search_Retry_Button_Click"
//
//    // Remote Events
//    case RemoteChannelFilterClick = "Remote_Channel_Filter_Click"
//    case RemoteChannelFilterSelected = "Remote_Channel_Filter_Selected"
//    case RemoteChannelNumberSearched = "Remote_Channel_Number_Searched"
//    case RemoteItemClick = "Remote_Item_Click"
//    case RemoteChannelSearchClick = "Remote_Channel_Search_Click"
//    case RemoteChannelSearchCancelled = "Remote_Channel_Search_Cancelled"
//    case RemoteScreenScroll = "Remote_Screen_Scroll"
//
//    // Item Description Page
//    case ItemDescriptionOpened = "Item_Description_Opened"
//    case SeeImdbDetailsClick = "IMDb_Details"
//
//    case SimilarShowsViewAllClick = "Similar_Shows_View_All_Click"
//    case SimilarShowsItemClick = "Similar_Shows_Item_Click"
//    case AllAirtimesClick = "All_Airtimes_Click"
//    case AddedToWatchlist = "Added_To_Watchlist"
//
//    case UndoWatchlist = "Undo_Watchlist"
//    case ViewingOptionsClick = "Viewing_Options_Click"
//
//    // Watchlist Tab
//    case WatchlistSegmentClick = "Watchlist_Segment_Click"
//    case OpenWatchlistedItem = "Open_Watchlisted_Item"
//
//    // Tracker Tab
//    case TrackerSegmentClick = "Tracker_Segment_Click"
//    case OpenTrackedItem = "Open_Tracked_Item"
//
//    // Register and Onboarding Events
//    case SignUpNowClick = "SignUp_Now_Click"
//
//    case onboardingScreen = "Onboarding_Screen"
//    case continueWithFB = "Conitnue_With_Facebook_Click"
//    case continueWithEmail = "Continue_With_Email_Click"
//    case facebookLoginFailure = "Facebook_Login_Failure"
//    case emailLoginErrorPopup = "Error_Popup_Shown"
//    case signInTabClick = "Sign_In_Tab_Click"
//    case signUpTabClick = "Sign_Up_Tab_Click"
//    case doneButtonOnEmailLogin = "Done_Button_On_Email_Login"
//    case doneButtonOnEmailSignup = "Done_Button_On_Email_Signup"
//
//    // Full Listings
//    case FullListingsDateClick = "Full_Listings_Date_Click"
//    case FullListingsCategoryDropdownClick = "Full_Listings_Category_Dropdown_Click"
//    case FullListingsChannelDropdownClick = "Full_Listings_Channel_Dropdown_Click"
//
//    case FullListingsCategorySelected = "Full_Listings_Category_Selected"
//    case FullListingsChannelSelected = "Full_Listings_Channel_Selected"
//    case FullListingsSectionViewAllClick = "Full_Listings_View_All_Click"
//    case FullListingsItemClick = "Full_Listings_Item_Click"
//    case ChannelListingPageOpened = "Channel_Listing_Page_Opened"
//    case ChannelListingItemClick = "Channel_Listing_Item_Click"
//
//    // Search
//
//    case SearchClick = "Search_Click"
//    case SearchCancelled = "Search_Cancelled"
//    case SearchOccurred = "Item_Searched"
//    case ItemsShown = "Items_Shown"
//    case SearchItemClick = "Search_Item_Click"
//    case TrackSearchedItem = "Track_Searched_Item"
//    case OpenedDescriptionSearchedItem = "Opened_Description_Searched_Item"
//    case SearchInvalid = "Search_Invalid"
//
//    // Miscellaneous
//    case NotificationPermissionProvided = "Notification_Permission_Provided"
//
//}

enum EventName: String {
    case DeviceSessionGenerated = "Device_Session_Generated"
    
    case TimeZonePreferenceSelectionShown = "TimeZone_Preference_Selection_Shown"
    case PreferenceSelectionDone = "Preference_Selection_Done"
    case TimeZonePreferenceDoneButtonTap = "TimeZone_Preference_Done_Button_Tap"
    
    case UserViewNavigationButtonClick = "User_View_Navigation_Button_Click"
    
    case TodayPageLoaded = "Today_Page_Loaded"
    case DiscoverPageLoaded = "Discover_Page_Loaded"
    case Next7DaysPageLoaded = "Next_7_Days_Page_Loaded"
    
    case TodayScreenScroll = "Today_Screen_Scroll"
    case Next7DaysScreenScroll = "Next_7_Days_Screen_Scroll"
    case DiscoverScreenScroll = "Discover_Screen_Scroll"
    
    case SectionHorizontalScroll = "Section_Horizontal_Scroll"
    
    case WatchlistViewAllClick = "Watchlist_View_All_Tap"
    case WatchlistItemClick = "Watchlist_Item_Tap"
    
    case DiscoverViewAllClick = "Discover_List_View_All_Tap"
    case DiscoverListScroll = "Discover_List_Scroll"
    case DiscoverItemClick = "Discover_List_Item_Tap"
    
    case GenreViewAllClick = "Genre_View_All_Tap"
    case GenreItemClick = "Genre_Item_Tap"
    case SectionViewAllClick = "Section_View_All_Tap"
    
    case ChannelListingViewAllTap = "Channel_Full_Listings_Tap"
    
    // Add to watchlist popup
    
    case AddButtonTap = "Add_Button_Tap"
    case EditButtonTap = "Edit_Button_Tap"
    case SeenButtonTap = "Seen_Button_Tap"
    case AddToWatchlistCancelButtonTap = "Add_To_Watchlist_Cancel_Button_Tap"
    case AddToWatchlistDoneButtonTap = "Add_To_Watchlist_Done_Button_Tap"
    case AddToWatchlistEnableAlerts = "Add_To_Watchlist_Enable_Alerts"
    case AddToWatchlistAlertOptions = "Add_To_Watchlist_Alert_Options"
    
    case ResizerButtonTap = "Resizer_Button_Tap"
    
    // User
    case UserSettingButtonTap = "User_Settings_Button_Tap"
    case UserSignUpNowClick = "User_SignUp_Now_Tap"
    case UserSignUpSkipButtonTap = "User_SignUp_Skip_Button_Tap"
    
    case UserMenuWatchlistTap = "User_Menu_Watchlist_Tap"
    case UserMenuSeenlistTap = "User_Menu_Seenlist_Tap"
    case UserMenuWhatsOnTap = "User_Menu_Whats_On_Now_Tap"
    case UserMenuTodayTap = "User_Menu_Today_Tap"
    case UserMenuNext7DayTap = "User_Menu_Next_7_Day_Tap"
    case UserMenuDiscoverTap = "User_Menu_Discover_Tap"
    
    // User Settings
    
    case UserSettingsItemTap = "User_Settings_Item_Tap"
    case UserSettingsAlertPreferenceSwitch = "User_Settings_Alert_Preference_Switch"
    
    // User Alert Option Settings
    case UserAlertOptionsPreferenceChange = "User_Alert_Options_Preference_Change"
    
    // Upgrade Now Popup
    
    case UpgradeNowPopupShown = "Upgrade_Now_Popup_Shown"
    case UpgradeNowPopupDismissTap = "Upgrade_Now_Popup_Dismiss_Tap"
    case UpgradeNowPopupUpgradeNowTap = "Upgrade_Now_Popup_Upgrade_Now_Tap"
    
    // User Upgrade View
    
    case UserUpgradeAvailableProductsLoaded = "User_Upgrade_Available_Products_Loaded"
    case UserUpgradeMonthlyPurchaseButtonTap = "User_Upgrade_Monthly_Purchase_Button_Tap"
    case UserUpgradeYearlyPurchaseButtonTap = "User_Upgrade_Yearly_Purchase_Button_Tap"
    case UserUpgradePaymentSuccessull = "User_Upgrade_Payment_Successull_Woohoo!"
    case UserUpgradePaymentFailedCancelled = "User_Upgrade_Payment_Failed_Cancelled"
    
    // Watchlist
    case EmptyDiscoverButtonTap = "Watchlist_Empty_Button_Tap"
    case WatchlistSegmentClick = "Watchlist_Segment_Tap"
    case OpenWatchlistedItem = "Open_Watchlisted_Item"
    case WatchlistDataLoaded = "Watchlist_Data_Loaded"
    case WatchlistShowAlertsOnlyTap = "Watchlist_Show_Alerts_Only_Tap"
    case WatchlistSortOptionsTap = "Watchlist_Sort_Options_Tap"
    case WatchlistSelectedSortOption = "Watchlist_Selected_Sort_Option"
    case WatchlistSortOptionCancelTap = "Watchlist_Sort_Option_Cancel_Tap"
    case WatchlistMarkSeenTap = "Watchlist_Mark_Seen_Tap"
    case WatchlistEditTap = "Watchlist_Edit_Tap"
    
    // Seen List
    case SeenListSegmentClick = "Seen_List_Segment_Tap"
    case SeenListDataLoaded = "Seen_List_Data_Loaded"
    case OpenSeenlistedItem = "Seen_List_Item_Tap"
    case RemoveSeenItem = "Seen_List_Remove_Item"
    
    case SearchFloatButtonTap = "Search_Float_Button_Tap"
    
    // Whats On Section now Section
    case WhatsOnItemTap = "Whats_On_Item_Tap"
    case WhatsOnDataLoaded = "Whats_On_Data_Loaded"
    case WhatsOnChannelFilterTap = "Whats_On_Channel_Filter_Tap"
    case WhatsOnNowButtonTap = "Whats_On_Now_Button_Tap"
    case WhatsOnLaterButtonTap = "Whats_On_Later_Button_Tap"
    
    
    //
    case ChannelItemTap = "Channel_Item_Tap"
    
    // Tab Events
    case HomeTabClick = "Home_Tab_Click"
    case SearchTabClick = "Search_Tab_Click"
    case WatchlistTabClick = "Watchlist_Tab_Click"
    
    case TrackerTabClick = "Tracker_Tab_Click"
    case RemoteTabClick = "Remote_Tab_Click"
    
    
    // Home
    case HomeSegmentClick = "Home_Segment_Click"
    case HomeScreenScroll = "Home_Screen_Scroll"
    case HomePageLoaded = "Home_Page_Loaded"
    
    case HomeSectionHorizontalScroll = "Home_Section_Horizontal_Scroll"
    
    case HomeWatchlistViewAllClick = "Home_Watchlist_View_All_Click"
    case HomeWatchlistItemClick = "Home_Watchlist_Item_Click"
    case HomeAiringNowPlayClick = "Home_Airing_Now_Play_Click"
    case HomeAiringNowViewAllClick = "Home_Airing_Now_View_All_Click"
    case HomeAiringNowItemClick = "Home_Airing_Now_Item_Click"
    
    case HomeDiscoverViewAllClick = "Home_Discover_View_All_Click"
    case HomeDiscoverScroll = "Home_Discover_Scroll"
    case HomeDiscoverItemClick = "Home_Discover_Item_Click"
    
    case HomeGenreViewAllClick = "Home_Genre_View_All_Click"
    case HomeGenreItemClick = "Home_Genre_Item_Click"
    
    case HomeArticlesItemClick = "Home_Articles_Item_Click"
    case HomeArticlesViewAllClick = "Home_Articles_View_All_Click"
    case HomeArticlesScroll = "Home_Articles_Scroll"
    
    case HomeMajorVideoItemClick = "Home_Major_Video_Item_Click"
    case HomeVideosItemClick = "Home_Videos_Item_Click"
    case HomeVideosViewAllClick = "Home_Videos_View_All_Click"
    case HomeSectionViewAllClick = "Home_Section_View_All_Click"
    
    case AddedToTracker = "Added_To_Tracker"
    case UndoTracker = "Undo_Track"
    
    case HomeRemoteConnectButtonClick = "Home_Remote_Connect_Button_Click"
    case HomeRemoteDoNotShowAgainClick = "Home_Remote_Do_Not_Show_Again_Click"
    
    case HomeProfileImageHotspotClick = "Home_Profile_Button_Hotspot_Click"
    
    // Home - Discover Page
    case DiscoverPageItemClick = "Discover_Page_Item_Tap"
    
    // Home - Genre
    case HomeAllGenresItemClick = "Home_All_Genres_Item_Click"
    case HomeGenrePageSegmentClick = "Home_Genre_Page_Segment_Click"
    case HomeGenrePageItemClick = "Home_Genre_Page_Item_Click"
    
    // Home - Articles
    case HomeAllArticlesItemClick = "Home_All_Articles_Item_Click"
    
    // Home - Videos
    case HomeAllVideosItemClick = "Home_All_Videos_Item_Click"
    
    // Device Connect Events
    
    case DeviceConnectPopupDismissed = "Device_Connect_Popup_Dismissed"
    case DeviceConnectPopupDontHaveDirecTV = "Device_Connect_Popup_Not_A_DirecTV_Customer"
    case DeviceConnectPopupSearchConnectedDevice = "Device_Connect_Popup_Search_Connected_Devices"
    
    case DeviceSearchDirecTVDeviceFound = "Device_Search_DirecTV_Device_Found"
    case DeviceSearchDirecTVDeviceShown = "Device_Search_DirecTV_Device_Shown"
    case DeviceSearchDirecTVDeviceSelected = "Device_Search_DirecTV_Device_Selected"
    case DeviceSearchNoDeviceFound = "Device_Search_No_Device_Found"
    case DeviceSearchRetryButtonClick = "Device_Search_Retry_Button_Click"
    
    // Remote Events
    case RemoteChannelFilterClick = "Remote_Channel_Filter_Click"
    case RemoteChannelFilterSelected = "Remote_Channel_Filter_Selected"
    case RemoteChannelNumberSearched = "Remote_Channel_Number_Searched"
    case RemoteItemClick = "Remote_Item_Click"
    case RemoteChannelSearchClick = "Remote_Channel_Search_Click"
    case RemoteChannelSearchCancelled = "Remote_Channel_Search_Cancelled"
    case RemoteScreenScroll = "Remote_Screen_Scroll"
    
    // Item Description Page
    case ItemDescriptionOpened = "Item_Description_Opened"
    case SeeImdbDetailsClick = "IMDb_Details"
    
    case SimilarShowsViewAllClick = "Similar_Shows_View_All_Click"
    case SimilarShowsItemClick = "Similar_Shows_Item_Click"
    case AllAirtimesClick = "All_Airtimes_Click"
    case AddedToWatchlist = "Added_To_Watchlist"
    
    case UndoWatchlist = "Undo_Watchlist"
    case ViewingOptionsClick = "Viewing_Options_Click"
    
    // Tracker Tab
    case TrackerSegmentClick = "Tracker_Segment_Click"
    case OpenTrackedItem = "Open_Tracked_Item"
    
    // Register and Onboarding Events
    
    case onboardingScreen = "Onboarding_Screen"
    case continueWithFB = "Conitnue_With_Facebook_Click"
    case continueWithEmail = "Continue_With_Email_Click"
    case facebookLoginFailure = "Facebook_Login_Failure"
    case emailLoginErrorPopup = "Error_Popup_Shown"
    case signInTabClick = "Sign_In_Tab_Click"
    case signUpTabClick = "Sign_Up_Tab_Click"
    case doneButtonOnEmailLogin = "Done_Button_On_Email_Login"
    case doneButtonOnEmailSignup = "Done_Button_On_Email_Signup"
    
    // Full Listings
    case FullListingsDateClick = "Full_Listings_Date_Click"
    case FullListingsCategoryDropdownClick = "Full_Listings_Category_Dropdown_Click"
    case FullListingsChannelDropdownClick = "Full_Listings_Channel_Dropdown_Click"
    
    case FullListingsCategorySelected = "Full_Listings_Category_Selected"
    case FullListingsChannelSelected = "Full_Listings_Channel_Selected"
    case FullListingsSectionViewAllClick = "Full_Listings_View_All_Click"
    case FullListingsItemClick = "Full_Listings_Item_Click"
    case ChannelListingPageOpened = "Channel_Listing_Page_Opened"
    case ChannelListingItemClick = "Channel_Listing_Item_Click"
    
    // Search
    
    case SearchClick = "Search_Click"
    case SearchCancelled = "Search_Cancelled"
    case SearchOccurred = "Item_Searched"
    case ItemsShown = "Items_Shown"
    case SearchItemClick = "Search_Item_Click"
    case TrackSearchedItem = "Track_Searched_Item"
    case OpenedDescriptionSearchedItem = "Opened_Description_Searched_Item"
    case SearchInvalid = "Search_Invalid"
    
    // Miscellaneous
    case NotificationPermissionProvided = "Notification_Permission_Provided"
    
}
