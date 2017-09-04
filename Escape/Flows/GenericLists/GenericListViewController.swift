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
    case ActivityIndicatorCell="GenericActivityIndicatorCell"
    case EscapeCell="GenericEscapeCell"
    case TaggedEscapeCell="TaggedEscapeCell"
    case PeopleCell="GenericPeopleCell"
    case ListingMediaDetailsCell="ListingMediaDetailsCell"
    case ArticleItemCell = "ArticleItemCell"
    case SingleVideoSmallCell = "SingleVideoSmallCell"
}

class GenericListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var registerableCells: [GenericCellIdentifier] = [.ActivityIndicatorCell, .EscapeCell, .TaggedEscapeCell,.ArticleItemCell,.ListingMediaDetailsCell, .SingleVideoSmallCell, .PeopleCell]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initXibs()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func initXibs() {
        for genericCell in registerableCells {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
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
