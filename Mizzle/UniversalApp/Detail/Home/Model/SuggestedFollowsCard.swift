//
//  SuggestedFollowsCard.swift
//  Escape
//
//  Created by Ankit on 09/02/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class SuggestedFollowsCard: StoryCard {
    
    var suggestedFollows : [MyAccountItems] = []
    
    override init(dict: [String : AnyObject]) {
        super.init(dict: dict)
        parseData()
        
    }
    
    func parseData(){
        if let objectData = self.storyData{
            for data in objectData{
                if let dict = data as? [String:AnyObject]{
                    self.suggestedFollows.append(MyAccountItems(dict: dict, userType: nil))
                }
            }
        }
    }

}
