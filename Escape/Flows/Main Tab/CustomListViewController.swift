//
//  CustomListViewController.swift
//  Escape
//
//  Created by Ankit on 07/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class CustomListViewController: UIViewController {
    
    var typeOfList:EscapeType!
    
    @IBOutlet weak var tableView: UITableView!
    

    var tableDataArray : [MyAccountEscapeItems] = []
    var storedOffsets = [Int: CGFloat]()
    var escapeType : EscapeType = .Movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if typeOfList == .Activity{
            
            
        }else if typeOfList == .Movie{
            escapeType = .Movie
            
        }else if typeOfList == .TvShows{
            escapeType = .TvShows
            
        }else if typeOfList == .Books{
            escapeType = .Books
            
        }
        
        MyAccountDataProvider.sharedDataProvider.escapeItemsDelegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchEscapesDataFromRealm()
        MyAccountDataProvider.sharedDataProvider.getUserEscapes(escapeType)
        
    }
    
    func fetchEscapesDataFromRealm(){
        
        if let user = MyAccountDataProvider.sharedDataProvider.currentUser{
            
            let escapeType = typeOfList.rawValue
           
            let predicate = NSPredicate(format: "escapeType == %@", escapeType)
            
            var dataArray : [MyAccountEscapeItems] = []
            
             let list = user.escapeList.filter(predicate)
             if list.count > 0 {
                var distinctElement : [String] = []
                
                for i in list{
                    if let section = i.sectionTitle{
                        
                        var check = true
                        for j in distinctElement{
                            if j == section{
                                check = false
                                break
                            }
                        }
                        if (check){
                            distinctElement.append(section)
                        }
                    }
                }
                
                for item in distinctElement{
                    let predicate = NSPredicate(format: "sectionTitle == %@", item)
                    let sectionList = list.filter(predicate)
                    if sectionList.count > 0 {
                        
                        var title : String?
                        var count : NSNumber?
                        var escapeData : [EscapeDataItems] = []
                        
                        for item in sectionList{
                            title = item.sectionTitle
                            count = item.sectionCount
                            
                            if let escapeType = item.escapeType{
                                escapeData.append(EscapeDataItems(id: item.id, name: item.name, image: item.posterImage, escapeType: EscapeType(rawValue:escapeType)))
                            }
                            
                        }
                        dataArray.append(MyAccountEscapeItems(title: title, count: count, escapeData: escapeData))
                    }
                }
                
                reloadTableView(dataArray, escape_type: typeOfList)
    
                    
             }
            
            
        }
        
    }
    
    
    func reloadTableView(data: [MyAccountEscapeItems] , escape_type : EscapeType ){
        
        if (typeOfList == escape_type) {
            
            tableDataArray = []
            tableView.reloadData()
            tableDataArray = data
            tableView.reloadData()
        }
        
    }
    
}

extension CustomListViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableDataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCellIdentifier") as! CustomListTableViewCell
        cell.cellTitleLabel.text = tableDataArray[indexPath.row].title
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else{
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension CustomListViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let data = tableDataArray[collectionView.tag].escapeData{
            count = data.count
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewBasicCell", forIndexPath: indexPath) as! CustomListCollectionViewCell
        
        if let item = tableDataArray[collectionView.tag].escapeData{
            
            cell.titleLabel.text = item[indexPath.row].name
            cell.itemImage.downloadImageWithUrl(item[indexPath.row].image , placeHolder: UIImage(named: "movie_placeholder"))
            
            
            
        }

        return cell
    }
}
extension CustomListViewController : EscapeItemsProtocol{
    func recievedEscapeData(data: [MyAccountEscapeItems] , escape_type : EscapeType) {
        
        reloadTableView(data , escape_type: escape_type)
        
    }
    
    func errorEscapeData() {
        
    }
}

