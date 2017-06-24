//
//  DataConstants.swift
//  Escape
//
//  Created by Rahul Meena on 30/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum LoggedInUsing: Int {
    case Facebook = 1, Email = 2, Guest = 3
}

class DataConstants: NSObject {
    
    static let kDefaultFetchSize = 10 // This can only be changed, if changed on server
    
    
}
