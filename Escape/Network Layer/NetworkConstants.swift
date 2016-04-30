//
//  NetworkConstants.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum ServiceType : String{
    case ServiceTypePrivateApi = "http://api.escape-app.com/api/"
    //case ServiceTypePrivateApi = "staging"
    case testService = "http://api.androidhive.info/"
}
enum SubServiceType : String {
    case testSubService = "contacts/"
    case GetUsers = "users/"
    case FBSignIn = "signin_with_facebook"
    case EmailSignUp = "register_with_email"
    case EmailSigIn =  "login_with_email"
    case FetchInterests = "fetch_all_interests"
    case PostInterests = "user_interests"
    
}

class NetworkConstants: NSObject {
    
    

}
