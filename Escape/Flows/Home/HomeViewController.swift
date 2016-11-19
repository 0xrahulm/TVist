//
//  HomeViewController.swift
//  Escape
//
//  Created by Ankit on 03/08/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

enum CellIdentifier : String{
    case FBFriends = "fbFriendsIdentifier"
    case Seperator = "seperatorCellIdentifier"
}
enum CellHeight : CGFloat{
    case FBFriends = 200
    case Seperator = 125
    case AddtoEscape = 315
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray : [StoryCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        dataArray.append(StoryCard(storyType : .EmptyStory))
        dataArray.append(StoryCard(storyType : .EmptyStory))
        dataArray.append(StoryCard(storyType : .EmptyStory))
        tableView.reloadData()

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        HomeDataProvider.sharedDataProvider.homeDataDelegate = self
        HomeDataProvider.sharedDataProvider.getUserStroies()
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
    
    func configureSeperatorCell(tableView : UITableView, indexPath : NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Seperator.rawValue, forIndexPath: indexPath)
        
        return cell
    }
    
    func configureAddToEscapeCell(tableView : UITableView, indexPath : NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("addToEscapeIdentifier", forIndexPath: indexPath) as! AddToEscapeTableViewCell
        let data = dataArray[indexPath.row] as? AddToEscapeCard
        cell.homeCommentDelegate = self
        cell.indexPath = indexPath
        cell.escapeItems = data
        return cell
    }

}
extension HomeViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let storyType = dataArray[indexPath.row].storyType{
            switch storyType {
                
            case .FBFriendFollow:
                return CellHeight.FBFriends.rawValue
                
            case .AddToEscape:
                return CellHeight.AddtoEscape.rawValue
            
            case .Recommeded:
                return CellHeight.AddtoEscape.rawValue
                
            case .EmptyStory:
                return CellHeight.Seperator.rawValue
                
            }
        }
        return CellHeight.Seperator.rawValue
        
    }
    
}
extension HomeViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
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
                return configureSeperatorCell(tableView, indexPath: indexPath)
            
            }
        }
        
        return configureSeperatorCell(tableView,indexPath: indexPath)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension HomeViewController : HomeDataProtocol{
    func recievedStories(data: [BaseStory]) {
        if let data = data as? [StoryCard]{
            self.dataArray = data
            tableView.reloadDataAnimated()
            
        }
    }
    func error() { 
        
    }
}
extension HomeViewController : HomeCommentProtocol{
    func commentTapped(indexPath: NSIndexPath) {
        if dataArray.count > indexPath.row{
            let story = dataArray[indexPath.row]
            if let storyId = story.id{
                performSegueWithIdentifier("showStoryCommentSegue", sender: ["id" : storyId])
            }
        }
    }
}

