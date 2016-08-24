//
//  NoNetworkView.swift
//  Escape
//
//  Created by Ankit on 24/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class NoNetworkView: UINibView {

    override func getNibName() -> String{
        return "NoNetworkView"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        
        ScreenVader.sharedVader.performScreenManagerAction(.NetworkPresent, queryParams: nil)
    }

}
