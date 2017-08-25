//
//  GenreItem.swift
//  Mizzle
//
//  Created by Rahul Meena on 24/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GenreItem: NSObject {
    
    var id: String!
    var name: String!
    var displayImage: String?

    func parseGenreItemData(_ data: [String:AnyObject]) -> GenreItem? {
        guard let name = data["name"] as? String, let id = data["id"] as? String else { return nil }
        
        let genreItem = GenreItem()
        
        genreItem.id = id
        genreItem.name = name
        genreItem.displayImage = data["display_image"] as? String
        
        return genreItem
    }
}
