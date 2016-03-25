//
//  NetworkConstants.swift
//  Escape
//
//  Created by Ankit on 22/03/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum ServiceType : String{
    case ServiceTypePrivateApi = "http://172.16.1.64:3000/api/"
    //case ServiceTypePrivateApi = "http://api.androidhive.info/"
    case testService = "http://api.androidhive.info/"
}
enum SubServiceType : String {
    case testSubService = "contacts/"
    case getUsers = "users/"
    case FBSignIn = "signin_with_facebook"
}

class NetworkConstants: NSObject {
    
    

}
