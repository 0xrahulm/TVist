//
//  Logger.swift
//  Escape
//
//  Created by Rahul Meena on 15/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation

class Logger {
    class func debug(_ debugObject: Any) {
        if ChiefVader.sharedVader.isDebugMode {
            print(debugObject)
        }
    }
}

