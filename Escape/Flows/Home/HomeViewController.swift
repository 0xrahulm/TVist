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
enum CellHeight : CGFloat{
    case fbFriends = 200
    case placeHolder = 250
    case addtoEscape = 315
    case whatsYourEscape = 123
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray : [StoryCard] = []
    var cardsTypeArray : [CellIdentifier] = [.FBFriends, .PlaceHolder, .Article, . AddToEscape, .WhatsYourEscape, .SuggestedFollow]
    
    var currentPage = 0
    var callFurther = true
    var animateOneTime = true
    var presentToast : UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        presentToast = UIApplication.shared.keyWindow
        
        dataArray.append(StoryCard(storyType : .emptyStory))
        dataArray.append(StoryCard(storyType : .emptyStory))
        dataArray.append(StoryCard(storyType : .emptyStory))
        
        initXibs()
        initNotificationObserver()
        
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        tableView.reloadData()
        
        HomeDataProvider.sharedDataProvider.homeDataDelegate = self
        loadMoreData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.receivedNotification(_:)), name:NSNotification.Name(rawValue: NotificationObservers.HomeClickObserver.rawValue), object: nil)
    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationObservers.HomeClickObserver.rawValue), object: nil)
    }
    func receivedNotification(_ notification : Notification){
           //tableView.setContentOffset(CGPointZero, animated:true)
        
    }
    
    func initXibs(){
        
        for cardType in cardsTypeArray{
            tableView.register(UINib(nibName: cardType.rawValue, bundle: nil), forCellReuseIdentifier: cardType.rawValue)
        }

    }
    
    func loadMoreData(){
        if callFurther{
            currentPage = currentPage + 1
            HomeDataProvider.sharedDataProvider.getUserStroies(currentPage)
        }
        callFurther = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dict = sender as? [String:AnyObject]{
            if let storyId = dict["id"] as? String{
                if let commentVC = segue.destination as? HomeCommentViewController{
                    commentVC.storyId = storyId
                    self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                }
            }
        }
    }
    
    func configureFBFriendCell(_ tableView : UITableView , indexPath : IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.FBFriends.rawValue) as! FBFriendsTableViewCell
        let data = dataArray[indexPath.row] as? FBFriendCard
        cell.friendItems = data
        cell.removeFbCardDelegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func configurePlaceHolderCell(_ tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.PlaceHolder.rawValue, for: indexPath)
        
        return cell
    }
    
    func configureArticleCell(_ tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.Article.rawValue, for: indexPath) as! ArticleTableViewCell
        let data = dataArray[indexPath.row] as? ArticleCard
        cell.homeCommentDelegate = self
        cell.indexPath = indexPath
        cell.data = data
        return cell
    }
    
    func configureAddToEscapeCell(_ tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.AddToEscape.rawValue, for: indexPath) as! AddToEscapeTableViewCell
        let data = dataArray[indexPath.row] as? AddToEscapeCard
        cell.homeCommentDelegate = self
        cell.indexPath = indexPath
        cell.escapeItems = data
        return cell
    }
    
    func configureWhatsYourEscapeCell(_ tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.WhatsYourEscape.rawValue, for: indexPath) as! WhatsYourLatestEscapeCell
        
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
    
    func configureSuggestedFollowCell(_ tableView : UITableView, indexPath : IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SuggestedFollow.rawValue, for: indexPath) as! SuggestedFollowsTableViewCell
        let data = dataArray[indexPath.row] as? SuggestedFollowsCard
        //cell.changeDataDelegate = self
        //cell.dataIndexPath = indexPath
        cell.data = data
        return cell
    }
    

}
extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let storyType = dataArray[indexPath.row].storyType{
            switch storyType {
                
            case .fbFriendFollow:
                return CellHeight.fbFriends.rawValue
                
            case .addToEscape:
                return UITableViewAutomaticDimension
            
            case .recommeded:
                return UITableViewAutomaticDimension
                
            case .article:
                return UITableViewAutomaticDimension
                
            case .suggestedFollows:
                return UITableViewAutomaticDimension
                
            case .emptyStory:
                return CellHeight.placeHolder.rawValue
                
            case .whatsYourEscape:
                return CellHeight.whatsYourEscape.rawValue
                
            }
        }
        
        return 0
        
    }
    
}
extension HomeViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > 3 && indexPath.row >= dataArray.count - 5{
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let storyType = dataArray[indexPath.row].storyType{
            switch storyType {
            
            case .fbFriendFollow:
                return configureFBFriendCell(tableView, indexPath: indexPath)
            
            case .addToEscape:
                return configureAddToEscapeCell(tableView, indexPath: indexPath)
                
            case .recommeded:
                return configureAddToEscapeCell(tableView, indexPath: indexPath)
                
            case .emptyStory:
                return configurePlaceHolderCell(tableView, indexPath: indexPath)
                
            case .article:
                return configureArticleCell(tableView, indexPath: indexPath)
                
            case .whatsYourEscape:
                return configureWhatsYourEscapeCell(tableView, indexPath: indexPath)
                
            case .suggestedFollows:
                return configureSuggestedFollowCell(tableView, indexPath : indexPath)
            
            }
        }
        
        return configurePlaceHolderCell(tableView,indexPath: indexPath)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension HomeViewController : HomeDataProtocol{
    func recievedStories(_ data: [BaseStory]) {
        if let data = data as? [StoryCard]{
            
            addWhatsYourEscapeCard()
            self.dataArray.append(contentsOf: data)
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
            if dataArray[0].storyType == .emptyStory{
                self.dataArray = []
                self.dataArray.append(StoryCard(storyType : .whatsYourEscape))
            }
        }else if dataArray.count == 0{
            self.dataArray.append(StoryCard(storyType : .whatsYourEscape))
        }
        
    }
}
extension HomeViewController : HomeCommentProtocol{
    func commentTapped(_ indexPath: IndexPath) {
        if dataArray.count > indexPath.row{
            
            let story = dataArray[indexPath.row]
            if let storyId = story.id{
                //performSegueWithIdentifier("showStoryCommentSegue", sender: ["id" : storyId])
                
                ScreenVader.sharedVader.performScreenManagerAction(.OpenSingleStoryView, queryParams: ["id" : storyId])
            }
        }
        
        
    }
}
extension HomeViewController : RemoveFbCardProtocol{
    func removeFBCard(_ indexPath: IndexPath) {
        if dataArray.count > indexPath.row{
            dataArray.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .right)
        
        if dataArray.count == 1{
            callFurther = true
            currentPage = 0
            loadMoreData()
        }
        
        if let toast = self.presentToast {
            
            toast.makeToast(message: "Facebook Friends followed. You can check them in your My Account section.", duration: 3.0, position: HRToastPositionDefault as AnyObject)
        }
    }
}
//extension HomeViewController : ChangeDataForFollosProtocol{
//    func changeDataArray(dataIndexPath : NSIndexPath, followerIndexPath : NSIndexPath, isFollow : Bool){
//        if dataArray.count > dataIndexPath.row{
//            if let data = dataArray[dataIndexPath.row] as? SuggestedFollowsCard{
//                if data.suggestedFollows.count > followerIndexPath.row{
//                    data.suggestedFollows[followerIndexPath.row].isFollow = isFollow
//                }
//            }
//        }
//    }
//}

