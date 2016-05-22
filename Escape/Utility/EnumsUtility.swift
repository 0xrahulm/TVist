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
}
enum StoryBoardIdentifier : String{
    case Onboarding = "Onboarding"
    case MainTab = "MainTab"
    case MyAccount = "MyAccount"
}
enum LoginTypeEnum : String {
    case Facebook = "fb"
    case Email    = "email"
}
enum Gender : Int{
    case Male = 1
    case Femeal = 2
}
enum EscapeType : String{
    case Activity = "activity"
    case Movie = "movie"
    case TvShows = "tv_show"
    case Books = "book"
}
enum Tap : Int{
    case Activity = 1
    case Movie = 2
    case TvShows = 3
    case Books = 4
}
