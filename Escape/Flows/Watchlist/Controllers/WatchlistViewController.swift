//
//  WatchlistViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 02/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class WatchlistViewController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var listOfItemType:[GuideListType] = [.All, .Television, .Movie]
    var titleForItem: [GuideListType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    var listControllers: [WatchlistChildViewController] = []
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var userDetailView: UserDetailView!
    
    var loadedOnce:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Watchlist"
        self.userDetailView.viewType = "Watchlist"
        for eachItem in listOfItemType {
            addChildVC(type: eachItem)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if !loadedOnce {
            loadedOnce = true
            self.view.layoutIfNeeded()
            setupPageMenu()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getName() -> String {
        return ScreenNames.Watchlist.rawValue
    }
    
    func setupPageMenu() {
        
        // Customize menu
        let parameters: [CAPSPageMenuOption] = [
            .hideTopMenuBar(true)
        ]
        
        
        pageMenu = CAPSPageMenu(viewControllers: listControllers, frame: CGRect(x: 0.0, y: 0.0, width: self.containerView.frame.width, height: self.containerView.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.containerView.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        pageMenu!.delegate = self
    }
    
    func addChildVC(type: GuideListType) {
        if let childVC = UIStoryboard(name: StoryBoardIdentifier.Watchlist.rawValue, bundle: nil).instantiateViewController(withIdentifier: "watchlistChildVC") as? WatchlistChildViewController {
            
            childVC.title = titleForItem[type]
            childVC.listType = type
            listControllers.append(childVC)
        }
    }
    
    func bringToTopWithIndex(index: Int) {
        self.pageMenu?.moveToPage(index)
    }
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        if let titleItem = titleForItem[listOfItemType[sender.selectedSegmentIndex]] {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.WatchlistSegmentClick, properties: ["Selected Tab":titleItem])
        }
        bringToTopWithIndex(index: sender.selectedSegmentIndex)
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


extension WatchlistViewController: CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        // Blank for now
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        self.segmentedControl.selectedSegmentIndex = index
    }
}

