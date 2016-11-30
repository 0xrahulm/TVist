//
//  GenericListViewController.swift
//  Escape
//
//  Created by Rahul Meena on 29/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum GenericCellIdentifier:String {
    case NormalCell="GenericCellIdentifier"
    case ActivityIndicatorCell="GenericActivityIndicatorCellIdentifier"
    case EscapeCell="GenericEscapeCellIdentifier"
    case TaggedEscapeCell="TaggedEscapeCellIdentifier"
    case PeopleCell="GenericPeopleCellIdentifier"
}

class GenericListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return listItemAtIndexPath(indexPath)
    }
    
    
    // MARK: - Methods to be implemented in child classes
    
    func listCount() -> Int {
        return 0
    }
    
    
    func listItemAtIndexPath(indexPath: NSIndexPath) -> NormalCell {
        return NormalCell()
    }

}
