//
//  GenericMasterViewController.swift
//  TVist
//
//  Created by Rahul Meena on 10/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class GenericDetailViewController: BaseViewController {
    
    @IBOutlet weak var masterHeaderView: MasterHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var displayModeButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.masterHeaderView.delegate = self
        
        self.tableView.contentInset = UIEdgeInsets(top: self.masterHeaderView.headerHeight.constant, left: 0, bottom: 40, right: 0)
        
        if self.view.traitCollection.horizontalSizeClass == .regular {
            enableResizerButton()
        } else {
            enableProfileBackButton()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func enableProfileBackButton() {
        if self.masterHeaderView != nil {
            self.masterHeaderView.setUserProfileBackButton()
        }
    }
    
    func enableResizerButton() {

        if let displayModeButtonItem = displayModeButtonItem, self.masterHeaderView != nil {
            self.masterHeaderView.setResizerButton(displayModeButton: displayModeButtonItem)
        }
    }

}

extension GenericDetailViewController: MasterHeaderViewProtocol {
    func didTapLeftNavButton() {
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.OpenUserView, queryParams: nil)
    }
}
