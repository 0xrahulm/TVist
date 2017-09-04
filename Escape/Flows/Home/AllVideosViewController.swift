//
//  AllVideosViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 31/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AllVideosViewController: GenericAllItemsListViewController {
    
    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    @IBOutlet weak var heightOfPlayerView: NSLayoutConstraint!
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let title = queryParams["title"] as? String {
            self.title = title
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AllVideosViewController.receivedData(notification:)), name: Notification.Name(rawValue:NotificationObservers.AllVideosDataObserver.rawValue), object: nil)
        
        self.heightOfPlayerView.constant = self.view.frame.size.height*0.35
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func itemTapEvent(itemName: String, index: Int) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .HomeAllVideosItemClick, properties: ["VideoTitle":itemName, "Position":"\(index+1)"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func fetchRequest() {
        HomeDataProvider.shared.getAllVideosData(page: nextPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receivedData(notification: Notification) {
        if let data = notification.userInfo as? [String:AnyObject] {
            if let itemsData = data["items"] as? [VideoItem], let page = data["page"] as? Int {
                appendDataToBeListed(appendableData: itemsData, page: page)
            }
        }
        
        
        if self.listItems.count > 0 {
            if let firstItem = self.listItems[0] as? VideoItem {
                
                self.thumbnailImage.downloadImageWithUrl(firstItem.thumbnail, placeHolder: nil)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AllVideosViewController.playFirstItem))
                self.thumbView.addGestureRecognizer(tapGesture)
            }
            
        }
    }
    
    override func selectedVideoItem(videoItem: VideoItem) {
        loadAndPlayUrl(url: videoItem.link)
    }
    
    func loadVideoUrl(url: String) {
        if let nsUrl = URL(string: url) {
            self.youtubePlayerView.loadVideoURL(nsUrl)
        }
    }
    
    func playFirstItem() {
        
        if self.listItems.count > 0 {
            if let firstItem = self.listItems[0] as? VideoItem {
                
                loadAndPlayUrl(url: firstItem.link)
            }
        }
    }
    
    func loadAndPlayUrl(url: String) {
        loadVideoUrl(url: url)
        playLoadedUrl()
    }
    
    func playLoadedUrl() {
        self.thumbView.isHidden = true
        self.youtubePlayerView.setWebViewBackground()
        self.youtubePlayerView.play()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
