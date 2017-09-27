//
//  HelpAndSupportViewController.swift
//  TVist
//
//  Created by Rahul Meena on 20/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class HelpAndSupportViewController: UITableViewController {
    
    var supportTickets: [SupportTicketItem] = []
    
    var selectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDataProvider.sharedDataProvider.supportTicketsDelegate = self
        UserDataProvider.sharedDataProvider.getAllSupportTickets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportTickets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let supportTicketItem = supportTickets[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpAndSupportCellReuseIdentifier", for: indexPath) as! SelectedOptionTableViewCell
        
        cell.setupSettingsCell(title: supportTicketItem.title)
        if let simpleId = supportTicketItem.simpleId {
         
            cell.selectedOptionLabel.text = "#\(simpleId)"
        }
        
        if indexPath.row == supportTickets.count-1 {
            cell.makeBottomLineFull()
        }
        
        cell.upperLine.isHidden = indexPath.row != 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        
        self.performSegue(withIdentifier: "ticketDetailsSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ticketDetailsSegue" {
            if let destinationVC = segue.destination as? TicketDetailViewController {
                destinationVC.supportTicketItem = supportTickets[self.selectedIndex]
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

extension HelpAndSupportViewController: SupportTicketsProtocol {
    func didCreateNewSupportTicket() {
        self.navigationController?.popToViewController(self, animated: true)
        ScreenVader.sharedVader.makeToast(toastStr: "New Support Ticket created")
    }
    func didRecieveSupportTickets(items: [SupportTicketItem]) {
        self.supportTickets = items
        self.tableView.reloadData()
        
        if items.count > 0 {
            
        }
    }
}
