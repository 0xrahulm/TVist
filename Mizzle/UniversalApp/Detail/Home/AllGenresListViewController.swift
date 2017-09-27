//
//  AllGenresListViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 31/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

enum AllGenresListCellIdentifiers: String {
    case GenreItemTableViewCell = "GenreItemTableViewCell"
}

class AllGenresListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var genreItems: [GenreItem] = []
    var registerableCells:[AllGenresListCellIdentifiers] = [.GenreItemTableViewCell]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Genre"
        HomeDataProvider.shared.genreDataDelegate = self
        HomeDataProvider.shared.getAllGenreData()
        loadingView.startAnimating()
        
        initXibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initXibs() {
        for genericCell in registerableCells {
            tableView.register(UINib(nibName: genericCell.rawValue, bundle: nil), forCellReuseIdentifier: genericCell.rawValue)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

}

extension AllGenresListViewController: GenreDataProtocol {
    func didReceiveAllGenreItems(items: [GenreItem]) {
        self.genreItems = items
        self.loadingView.stopAnimating()
        self.tableView.reloadData()
    }
    
    func errorRecievingGenreData() {
        
    }
}

extension AllGenresListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeightForBrowseByGenreSection.GenreCollectionViewCellHeight.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.genreItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AllGenresListCellIdentifiers.GenreItemTableViewCell.rawValue, for: indexPath) as! GenreItemTableViewCell
        cell.genreItem = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.genreItems[indexPath.row]
        ScreenVader.sharedVader.performUniversalScreenManagerAction(.openBrowseByGenreView, queryParams: ["genreItem": item])
        
        if let genreName = item.name {
            AnalyticsVader.sharedVader.basicEvents(eventName: .HomeAllGenresItemClick, properties: ["GenreName":genreName, "Position":"\(indexPath.row+1)"])
        }
    }
    
}
