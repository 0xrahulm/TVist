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
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
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
            tableView.register(UINib(nibName: cardType.rawValue, bundle: nil), forCellReuseIdentifier: cardType.rawValue)
        }
        
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
    
}
extension SingleStoryViewController : UITableViewDelegate{
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
                
            case .emptyStory:
                return CellHeight.placeHolder.rawValue
                
            default:
                return 0
            }
        }
        return 0
        
    }
    
}
extension SingleStoryViewController : UITableViewDataSource{
    
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
                
            default:
                return configurePlaceHolderCell(tableView,indexPath: indexPath)
            }
        }
        
        return configurePlaceHolderCell(tableView,indexPath: indexPath)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension SingleStoryViewController : SingleStoryProtocol{
    func recievedStory(_ story: BaseStory) {
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
    func commentTapped(_ indexPath: IndexPath) {
        if dataArray.count > indexPath.row{
            
            let story = dataArray[indexPath.row]
            if let storyId = story.id{
                performSegue(withIdentifier: "showStoryCommentSegue", sender: ["id" : storyId])
            }
        }
        
        
    }
}
