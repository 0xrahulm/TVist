//
//  MessageFactory.swift
//  Mizzle
//
//  Created by Rahul Meena on 12/05/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import Messages

enum SuggestionBubble {
    
    static var typeKey = "type"
}

class MessageFactory: NSObject {
    
    class func createAskSuggestionMessage(type: SearchType) -> MSMessage {
        let message = MSMessage()
        
        let layout = MSMessageTemplateLayout()
        
        if type == .Books {
            layout.image = UIImage(named: "Suggest_Book")
            layout.imageTitle = "Suggest a book to read."
        } else if type == .Movie {
            layout.image = UIImage(named: "Suggest_Movie")
            layout.imageTitle = "Suggest a movie to watch."
        } else if type == .TvShows {
            layout.image = UIImage(named: "Suggest_TvShow")
            layout.imageTitle = "Suggest a tv show to watch."
        } else {
            layout.image = UIImage(named: "Suggest_Anything")
            layout.imageTitle = "Suggest me something to read or watch."
        }
        
        layout.caption = "Tap to search & send"
        layout.subcaption = "via Mizzle"
        message.layout = layout
        
        //Create suggestion data pass
        let typeQueryItem = URLQueryItem(name: SuggestionBubble.typeKey, value: type.rawValue)
        var components = URLComponents()
        components.queryItems = [typeQueryItem]
        message.url = components.url
        
        return message
    }
    
    class func getSearchTypeWithConversation(conversation: MSConversation) -> String? {
        if let selectedMessage = conversation.selectedMessage {
            if let url = selectedMessage.url {
                
                if let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems {
                    
                    for eachItem in queryItems {
                        if eachItem.name == SuggestionBubble.typeKey {
                            return eachItem.value
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    class func createMediaItemMessage(searchItem: SearchItems, loadedImage: UIImage?) -> MSMessage {
        let message = MSMessage()
        
        let layout = MSMessageTemplateLayout()
        
        if let image = searchItem.image {
            layout.mediaFileURL = URL(string: image)
        }
        
        if let loadedImage = loadedImage {
            layout.image = loadedImage
        }
        layout.caption = searchItem.name
        
        layout.subcaption = searchItem.director
        
        layout.trailingSubcaption = "via Mizzle"
        
        message.layout = layout
        message.url = searchItem.getItemDeeplink()
        
        return message
    }

}


