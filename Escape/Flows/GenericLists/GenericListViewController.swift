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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return listItemAtIndexPath(indexPath)
    }
    
    
    // MARK: - Methods to be implemented in child classes
    
    func listCount() -> Int {
        return 0
    }
    
    
    func listItemAtIndexPath(_ indexPath: IndexPath) -> NormalCell {
        return NormalCell()
    }

}
