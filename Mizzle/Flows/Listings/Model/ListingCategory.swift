//
//  ListingCategories.swift
//  Mizzle
//
//  Created by Rahul Meena on 26/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class ListingCategory: NSObject {
    
    var id: String?
    var name: String?
    
    var isSelected: Bool = false
    
    class func createListingCategory(data: [String: Any]) -> ListingCategory? {
        guard let id = data["id"] as? String, let name = data["name"] as? String else { return nil }
        
        let listingCategory = ListingCategory()
        listingCategory.id = id
        listingCategory.name = name
        return listingCategory
    }
}
