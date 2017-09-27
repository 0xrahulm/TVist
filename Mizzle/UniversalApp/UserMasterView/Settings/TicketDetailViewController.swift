//
//  TicketDetailViewController.swift
//  TVist
//
//  Created by Rahul Meena on 20/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class TicketDetailViewController: UIViewController {
    
    var supportTicketItem: SupportTicketItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userDetailView: UserDetailView!
    @IBOutlet weak var bodyOfProblem: UILabel!
    @IBOutlet weak var titleOfProblem: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let simpleId = supportTicketItem.simpleId {
         
            self.title = "#\(simpleId)"
        }
        
        self.titleOfProblem.text = supportTicketItem.title
        self.bodyOfProblem.text = supportTicketItem.body
        
        if supportTicketItem.isOpen {
            self.isOpenLabel.backgroundColor = UIColor.styleGuideActionGreen()
            self.isOpenLabel.text = "  open  "
        } else {
            self.isOpenLabel.text = "  closed  "
            self.isOpenLabel.backgroundColor = UIColor.styleGuideActionRed()
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension TicketDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCellIdentifiers.messageCell.rawValue, for: indexPath) as! SettingsBaseTableViewCell
        
        cell.titleLabel.text = "No Replies yet"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
