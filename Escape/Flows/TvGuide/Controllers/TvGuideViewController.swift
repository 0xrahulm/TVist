//
//  TvGuideViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 12/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class TvGuideViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchInput: UITextField!
    
    var listOfItemType:[GuideListType] = [.All, .Television, .Movie]
    var titleForItem: [GuideListType: String] = [.All:"All", .Television: "Television", .Movie: "Movies"]
    var listControllers: [TvGuideChildViewController] = []
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        
        
        for eachItem in listOfItemType {
            addChildVC(type: eachItem)
        }
        
        setupPageMenu()
        
        pageMenu!.moveToPage(1)
        
    }
    
    func setupSearchBar(){
        
        
        searchInput.delegate = self
        
        searchInput.attributedPlaceholder = SFUIAttributedText.regularAttributedTextForString("Search television shows, movies", size: 19, color: UIColor.textGrayColor())
        
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
        if let childVC = UIStoryboard(name: StoryBoardIdentifier.TvGuide.rawValue, bundle: nil).instantiateViewController(withIdentifier: "tvGuideChildIdentifier") as? TvGuideChildViewController {
            
            childVC.title = titleForItem[type]
            childVC.listType = type
            listControllers.append(childVC)
        }
    }
    
    func bringToTop(type: GuideListType) {
        if let index = listOfItemType.index(of: type) {
            bringToTopWithIndex(index: index)
        }
    }
    
    func bringToTopWithIndex(index: Int) {
        self.pageMenu?.moveToPage(index)
    }
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        bringToTopWithIndex(index: sender.selectedSegmentIndex)
    }

}

extension TvGuideViewController: UITextFieldDelegate {
    
}

extension TvGuideViewController: CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        // Blank for now
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        self.segmentedControl.selectedSegmentIndex = index
    }
}
