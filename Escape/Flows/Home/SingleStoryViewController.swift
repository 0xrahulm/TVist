//
//  SingleStoryViewController.swift
//  Escape
//
//  Created by Ankit on 04/02/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

class SingleStoryViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var storyId : String?
    var dataArray : [StoryCard] = []
    var cardsTypeArray : [CellIdentifier] = [.FBFriends, .PlaceHolder, .Article, . AddToEscape, .WhatsYourEscape]
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        if let id = queryParams["id"] as? String{
            self.storyId = id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initXibs()

        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        tableView.reloadData()
        
        loadingView.startAnimating()
        
        HomeDataProvider.sharedDataProvider.singleStoryDelegate = self
        if let storyId = storyId{
            HomeDataProvider.sharedDataProvider.getSingleStrory(storyId)
        }
        
    }
    
    func initXibs(){
        
        for cardType in cardsTypeArray{
            tableView.registerNib(UINib(nibName: cardType.rawValue, bundle: nil), forCellReuseIdentifier: cardType.rawValue)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dict = sender as? [String:AnyObject]{
            if let storyId = dict["id"] as? String{
                if let commentVC = segue.destinationViewController as? HomeCommentViewController{
                    commentVC.storyId = storyId
                    self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                }
            }
        }
    }
    
    func configureFBFriendCell(tableView : UITableView , indexPath : NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.FBFriends.rawValue) as! FBFriendsTableViewCell
        let data = dataArray[indexPath.row] as? FBFriendCard
        cell.friendItems = data
        return cell
    }
    
    func configurePlaceHolderCell(tableView : UITableView, indexPath : NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.PlaceHolder.rawValue, forIndexPath: indexPath)
        
        return cell
    }
    
    func configureArticleCell(tableView : UITableView, indexPath : NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Article.rawValue, forIndexPath: indexPath) as! ArticleTableViewCell
        let data = dataArray[indexPath.row] as? ArticleCard
        cell.homeCommentDelegate = self
        cell.indexPath = indexPath
        cell.data = data
        return cell
    }
    
    func configureAddToEscapeCell(tableView : UITableView, indexPath : NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.AddToEscape.rawValue, forIndexPath: indexPath) as! AddToEscapeTableViewCell
        let data = dataArray[indexPath.row] as? AddToEscapeCard
        cell.homeCommentDelegate = self
        cell.indexPath = indexPath
        cell.escapeItems = data
        return cell
    }
    
}
extension SingleStoryViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let storyType = dataArray[indexPath.row].storyType{
            switch storyType {
                
            case .FBFriendFollow:
                return CellHeight.FBFriends.rawValue
                
            case .AddToEscape:
                return UITableViewAutomaticDimension
                
            case .Recommeded:
                return UITableViewAutomaticDimension
                
            case .Article:
                return UITableViewAutomaticDimension
                
            case .EmptyStory:
                return CellHeight.PlaceHolder.rawValue
                
            default:
                return 0
            }
        }
        return 0
        
    }
    
}
extension SingleStoryViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let storyType = dataArray[indexPath.row].storyType{
            switch storyType {
                
            case .FBFriendFollow:
                return configureFBFriendCell(tableView, indexPath: indexPath)
                
            case .AddToEscape:
                return configureAddToEscapeCell(tableView, indexPath: indexPath)
                
            case .Recommeded:
                return configureAddToEscapeCell(tableView, indexPath: indexPath)
                
            case .EmptyStory:
                return configurePlaceHolderCell(tableView, indexPath: indexPath)
                
            case .Article:
                return configureArticleCell(tableView, indexPath: indexPath)
                
            default:
                return configurePlaceHolderCell(tableView,indexPath: indexPath)
            }
        }
        
        return configurePlaceHolderCell(tableView,indexPath: indexPath)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension SingleStoryViewController : SingleStoryProtocol{
    func recievedStory(story: BaseStory) {
        loadingView.stopAnimating()
        if let story = story as? StoryCard{
            dataArray.append(story)
        }
        tableView.reloadData()
        
    }
    func error(){
        
    }
}
extension SingleStoryViewController : HomeCommentProtocol{
    func commentTapped(indexPath: NSIndexPath) {
        if dataArray.count > indexPath.row{
            
            let story = dataArray[indexPath.row]
            if let storyId = story.id{
                performSegueWithIdentifier("showStoryCommentSegue", sender: ["id" : storyId])
            }
        }
        
        
    }
}
