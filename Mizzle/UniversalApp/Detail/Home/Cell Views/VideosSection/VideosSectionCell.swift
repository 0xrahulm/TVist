//
//  VideosSectionCell.swift
//  Mizzle
//
//  Created by Rahul Meena on 29/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

enum VideosSectionCellIdentifier: String {
    case SingleVideoSmallCell = "SingleVideoSmallCell"
}

enum HeightForVideosSectionCell: CGFloat {
    case SingleVideoSmallCellHeight = 85
    case PlayerHeight = 220
}

class VideosSectionCell: HomeSectionBaseCell {
    
    var tableView: UITableView!
    
    var videoItems:[VideoItem] = []
    
    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    
    @IBOutlet weak var playerHeightConstraint: NSLayoutConstraint!
    
    weak var viewAllTapDelegate: ViewAllTapProtocol?
    
    
    var registerableCells:[VideosSectionCellIdentifier] = [.SingleVideoSmallCell]
    
    class func totalHeight(count: Int) -> CGFloat {
        if count > 0 {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                return (CGFloat(count)*HeightForVideosSectionCell.SingleVideoSmallCellHeight.rawValue)
            }
            return HeightForVideosSectionCell.PlayerHeight.rawValue + (CGFloat(count)*HeightForVideosSectionCell.SingleVideoSmallCellHeight.rawValue)
        }
        return 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        
    }
    
    func initXibs() {
        for genericCell in registerableCells {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
    func setDataAndInitialiseView(data: [VideoItem]) {
        
        
        if tableView == nil {
            if self.playerHeightConstraint != nil {
                self.playerHeightConstraint.constant = VideosSectionCell.totalHeight(count: data.count)
            }
            self.layoutIfNeeded()
            tableView = UITableView(frame: self.containerView.bounds, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            
            tableView.isScrollEnabled = false
            tableView.separatorColor = nil
            
            self.containerView.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = true
            tableView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
            tableView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            initXibs()
        }
        
        self.videoItems = data
        self.tableView.reloadData()
        
        if self.videoItems.count > 0 {
            let firstItem = self.videoItems[0]
            
            self.thumbnailImage.downloadImageWithUrl(firstItem.thumbnail, placeHolder: nil)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VideosSectionCell.playFirstItem))
            self.thumbView.addGestureRecognizer(tapGesture)
            
        }
    }
    
    func willDisplay() {
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    
    @IBAction func viewAllTapped() {
        if let viewAllTapDelegate = viewAllTapDelegate {
            viewAllTapDelegate.viewAllTappedIn(self)
        }
    }
    
    
    func loadVideoUrl(url: String) {
        if let nsUrl = URL(string: url) {
            self.youtubePlayerView.loadVideoURL(nsUrl)
        }
    }
    
    @objc func playFirstItem() {
        
        if self.videoItems.count > 0 {
            let firstItem = self.videoItems[0]
            if let firstItemTitle = firstItem.title {
                AnalyticsVader.sharedVader.basicEvents(eventName: .HomeMajorVideoItemClick, properties: ["videoTitle": firstItemTitle])
            }
            loadAndPlayUrl(url: firstItem.link)
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
    
}

extension VideosSectionCell:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightForVideosSectionCell.SingleVideoSmallCellHeight.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoItem = videoItems[indexPath.row]
        loadAndPlayUrl(url: videoItem.link)
        
        if let videoTitle = videoItem.title {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.HomeVideosItemClick, properties: ["Position":"\(indexPath.row+1)", "videoTitle": videoTitle])
        }
    }
}


extension VideosSectionCell:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let videoItem = videoItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VideosSectionCellIdentifier.SingleVideoSmallCell.rawValue, for: indexPath) as! SingleVideoSmallCell
        cell.videoItem = videoItem
        
        return cell
        
    }
}
