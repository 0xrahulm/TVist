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
}
enum CellHeight : CGFloat{
    case FBFriends = 200
    case PlaceHolder = 250
    case AddtoEscape = 315
    case WhatsYourEscape = 123
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray : [StoryCard] = []
    
    var currentPage = 0
    var callFurther = true
    var animateOneTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        dataArray.append(StoryCard(storyType : .EmptyStory))
        dataArray.append(StoryCard(storyType : .EmptyStory))
        dataArray.append(StoryCard(storyType : .EmptyStory))
        
        initXibs()
        initNotificationObserver()
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        tableView.reloadData()
        
        HomeDataProvider.sharedDataProvider.homeDataDelegate = self
        loadMoreData()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.receivedNotification(_:)), name:NotificationObservers.HomeTappedObserver.rawValue, object: nil)
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationObservers.HomeTappedObserver.rawValue, object: nil)
    }
    func receivedNotification(notification : NSNotification){
           //tableView.setContentOffset(CGPointZero, animated:true)
        
    }
    
    func initXibs(){
        tableView.registerNib(UINib(nibName: CellIdentifier.WhatsYourEscape.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.WhatsYourEscape.rawValue)
        
        tableView.registerNib(UINib(nibName: CellIdentifier.Article.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.Article.rawValue)
        
        tableView.registerNib(UINib(nibName: CellIdentifier.FBFriends.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.FBFriends.rawValue)
        
        tableView.registerNib(UINib(nibName: CellIdentifier.AddToEscape.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.AddToEscape.rawValue)
        
        tableView.registerNib(UINib(nibName: CellIdentifier.PlaceHolder.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.PlaceHolder.rawValue)
    }
    
    func loadMoreData(){
        if callFurther{
            currentPage = currentPage + 1
            HomeDataProvider.sharedDataProvider.getUserStroies(currentPage)
        }
        callFurther = false
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
    
    func configureWhatsYourEscapeCell(tableView : UITableView, indexPath : NSIndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.WhatsYourEscape.rawValue, forIndexPath: indexPath) as! WhatsYourLatestEscapeCell
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
            if let image = user.profilePicture{
                cell.imageStr = image
            }else{
                MyAccountDataProvider.sharedDataProvider.getUserDetails(nil)
            }
        }else{
            MyAccountDataProvider.sharedDataProvider.getUserDetails(nil)
        }
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
                return UITableViewAutomaticDimension
            
            case .Recommeded:
                return UITableViewAutomaticDimension
                
            case .Article:
                return UITableViewAutomaticDimension
                
            case .EmptyStory:
                return CellHeight.PlaceHolder.rawValue
                
            case .WhatsYourEscape:
                return CellHeight.WhatsYourEscape.rawValue
                
            }
        }
        return 0
        
    }
    
}
extension HomeViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 3 && indexPath.row >= dataArray.count - 5{
            loadMoreData()
        }
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
                return configurePlaceHolderCell(tableView, indexPath: indexPath)
                
            case .Article:
                return configureArticleCell(tableView, indexPath: indexPath)
                
            case .WhatsYourEscape:
                return configureWhatsYourEscapeCell(tableView, indexPath: indexPath)
            
            }
        }
        
        return configurePlaceHolderCell(tableView,indexPath: indexPath)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension HomeViewController : HomeDataProtocol{
    func recievedStories(data: [BaseStory]) {
        if let data = data as? [StoryCard]{
            
            addWhatsYourEscapeCard()
            self.dataArray.appendContentsOf(data)
            if animateOneTime{
                tableView.reloadDataAnimated()
            }else{
                tableView.reloadData()
            }
            animateOneTime = false
            
            if data.count > 5{
                callFurther = true
            }else{
              callFurther = false
            }
        }
    }
    
    func error() { 
        callFurther = false
    }
    
    func addWhatsYourEscapeCard(){
        if dataArray.count > 0 {
            if dataArray[0].storyType == .EmptyStory{
                self.dataArray = []
                self.dataArray.append(StoryCard(storyType : .WhatsYourEscape))
            }
        }else if dataArray.count == 0{
            self.dataArray.append(StoryCard(storyType : .WhatsYourEscape))
        }
        
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


