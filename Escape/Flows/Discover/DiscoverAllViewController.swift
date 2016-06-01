//
//  DiscoverAllViewController.swift
//  Escape
//
//  Created by Ankit on 29/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class DiscoverAllViewController: UIViewController {
    
    var type : DiscoverType = .All
    var dataArray : [DiscoverItems] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        dataArray = []
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("didappear : \(type)")
        
        DiscoverDataProvider.shareDataProvider.discoverDataDelegate = self
        DiscoverDataProvider.shareDataProvider.getDiscoverItems(type)
        
    }
    
    
    
    
}
extension DiscoverAllViewController : UITableViewDelegate{
    
}
extension DiscoverAllViewController : UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discoverEscapeCellIdentifier") as! DiscoverEscapeTableViewCell
        let data = dataArray[indexPath.row]
        cell.data = data
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
extension DiscoverAllViewController : DiscoverDataProtocol{
    func recievedDiscoverData(data: [DiscoverItems], discoverType: DiscoverType) {
        if self.type == discoverType{
            self.dataArray = data
            tableView.reloadData()
            
        }
        
    }
    func errorDiscoverData() {
        
    }
}
