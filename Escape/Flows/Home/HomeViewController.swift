//
//  HomeViewController.swift
//  Escape
//
//  Created by Ankit on 03/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum CellIdentifier : String{
    case FBFriends = "FBFriendView"
    case PlaceHolder = "PlaceHolderView"
    case Article = "ArticleView"
    case AddToEscape = "AddToEscapeView"
    case WhatsYourEscape = "WhatsYourEscape"
    case EscapeCollection = "EscapeCollectionView"
    case SuggestedFollow = "SuggestedFollows"
    case SuggestedPeopleCollection = "SuggestedPeopleCollectionView"
}

enum HomeCellIdentifiers: String {
    case MediaListCellIdentifier = "MediaListCell"
    case TrackingCellIdentifier = "TrackingCell"
    case ListingCellIdentifier = "ListingCellIdentifier"
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
}
