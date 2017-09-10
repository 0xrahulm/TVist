//
//  FBFriendCard.swift
//  Escape
//
//  Created by Ankit on 04/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class FBFriendCard: StoryCard {
    
    var friends : [MyAccountItems] = []
    
    override init(dict: [String : AnyObject]) {
        super.init(dict: dict)
        parseData()
        
    }
    
    func parseData(){
        if let objectData = self.storyData{
            for data in objectData{
                if let dict = data as? [String:AnyObject]{
                  self.friends.append(MyAccountItems(dict: dict, userType: nil))
                }
            }
        }
    }
}
