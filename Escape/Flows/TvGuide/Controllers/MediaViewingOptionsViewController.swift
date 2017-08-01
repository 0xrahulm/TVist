//
//  MediaViewingOptionsViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 05/07/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import SafariServices

class MediaViewingOptionsViewController: UIViewController {
    
    var viewingOptionType:ViewingOptionType = .Stream
    var mediaItem: EscapeItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyOptionsView: UIView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewingOptions: [StreamingOption] = []

    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        if let viewingOptionType = queryParams["viewingOptionType"] as? ViewingOptionType {
            self.viewingOptionType = viewingOptionType
        }
        
        if let mediaItem = queryParams["mediaItem"] as? EscapeItem {
            self.mediaItem = mediaItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = mediaItem.name
        
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.MediaViewOptionsListOpen, properties: ["escape_name": mediaItem.name, "escape_id":mediaItem.id])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIndicatorView.startAnimating()
        MediaDataProvider.shared.mediaViewingOptionsDelegate = self
        MediaDataProvider.shared.fetchViewingOptions(viewingOptionType: viewingOptionType, escapeId: mediaItem.id)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MediaViewingOptionsViewController: MediaViewingOptionsProtocol {
    func mediaViewingOptions(viewingOptions: [StreamingOption]) {
        self.viewingOptions = viewingOptions
        
        self.tableView.reloadData()
        self.activityIndicatorView.stopAnimating()
        
        if viewingOptions.count == 0 {
            self.emptyOptionsView.visibleWithAnimation()
        }
    }
}

extension MediaViewingOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let streamingOption = viewingOptions[indexPath.row]
        
            if let name = streamingOption.name {
                
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ViewingOptionSelected, properties: ["Service": name])
            }
        
            if let link = streamingOption.link {
                
                if let url = URL(string: link) {
                    if let scheme = url.scheme, scheme == "itms" {
                        UIApplication.shared.openURL(url)
                        return
                    }
                    let safari = SFSafariViewController(url: url)
                    self.present(safari, animated: true, completion: nil)
                }
            }
        
    }
}

extension MediaViewingOptionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewingOption = viewingOptions[indexPath.row]
        
        
        return UITableViewCell()
    }
}
