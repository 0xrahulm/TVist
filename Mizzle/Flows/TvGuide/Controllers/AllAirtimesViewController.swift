//
//  AllAirtimesViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AllAirtimesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noAirtimeView: UIView!
    
    var escapeId: String!
    
    var airtimes: [Airtime] = []
    
    var nextPage:Int = 1
    
    var fetchingData = false
    var fullDataLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        super.setObjectsWithQueryParameters(queryParams)
        
        if let escapeId = queryParams["escapeId"] as? String {
            self.escapeId = escapeId
        }
        
        if let title = queryParams["title"] as? String {
            self.title = title
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadNextPage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    func loadNextPage() {
        if !fetchingData && !fullDataLoaded {
            fetchingData = true
            fetchRequest()
        }
    }
    
    func fetchRequest() {
        activityIndicator.startAnimating()
        MediaDataProvider.shared.mediaAirtimesDelegate = self
        MediaDataProvider.shared.fetchAirtimes(escapeId: escapeId, page: nextPage)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)*0.66) {
            loadNextPage()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airtimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirtimeTableViewCell", for: indexPath) as! AirtimeTableViewCell
        
        let airtime = airtimes[indexPath.row]
        
        
        cell.dayTimeLabel.text = airtime.dayText()+", "+airtime.airTime
        
        if let episodeString = airtime.episodeString {
            cell.seasonEpisodeLabel.text = episodeString
        } else {
            cell.seasonEpisodeLabel.text = airtime.channelName
        }
        cell.channelImageView.downloadImageWithUrl(airtime.channelIcon, placeHolder: IconsUtility.airtimeIcon())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

extension AllAirtimesViewController:MediaAirtimesDataProtocol {
    func didReceiveAirtimes(airtimes: [Airtime]) {
        
        if airtimes.count < 10 {
            
            fullDataLoaded = true
        }
        
        fetchingData = false
        nextPage = nextPage + 1
        
        self.airtimes.append(contentsOf: airtimes)
        if self.airtimes.count == 0 && fullDataLoaded {
            self.noAirtimeView.visibleWithAnimation()
        }
        self.tableView.reloadData()
        activityIndicator.stopAnimating()
    }
}
