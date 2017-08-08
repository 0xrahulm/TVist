//
//  CustomListViewController.swift
//  Escape
//
//  Created by Ankit on 07/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import RealmSwift

class CustomListViewController: UIViewController {
    
    var typeOfList:ProfileListType!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataArray : [MyAccountEscapeItem] = []
    var storedOffsets = [Int: CGFloat]()
    var escapeType : ProfileListType = .Movie
    
    var lastContentOffsetY:CGFloat = 0.0
    
    var userId : String?
    
    weak var parentReference: MyAccountViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 170, right: 0)
        tableView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomListViewController.receivedNotification(_:)), name:NSNotification.Name(rawValue: NotificationObservers.MyAccountObserver.rawValue), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.escapeType  = typeOfList
        if userId == nil{
            fetchEscapesDataFromRealm()
        }
        
        // This is no longer used
//        MyAccountDataProvider.sharedDataProvider.getUserEscapes(escapeType, esc userId: userId)
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationObservers.MyAccountObserver.rawValue), object: nil)
    }
    
    func fetchEscapesDataFromRealm() {
        
        if let currentUserId = ECUserDefaults.getCurrentUserId(){
            
            let escapeType = typeOfList.rawValue
            
            let userDataPredicate = NSPredicate(format: "userId == %@ AND escapeType == %@", currentUserId, escapeType)
            
            do{
                let escapeData = try Realm().objects(UserEscapeData.self).filter(userDataPredicate)
                
                var dataArray : [MyAccountEscapeItem] = []
                
                let list = escapeData
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
                            var rating : NSNumber?
                            var year : String?
                            var escapeData : [EscapeDataItems] = []
                            
                            for item in sectionList{
                                title = item.sectionTitle
                                count = item.sectionCount
                                rating = item.rating
                                year = item.year
                                
                                if let escapeType = item.escapeType{
                                    escapeData.append(EscapeDataItems(id: item.id, name: item.name, image: item.posterImage, escapeType: EscapeType(rawValue:escapeType), escapeRating: rating, year: year))
                                }
                                
                            }
                            dataArray.append(MyAccountEscapeItem(title: title, count: count, escapeData: escapeData))
                        }
                    }
                    
                    reloadTableView(dataArray, escape_type: typeOfList)
                }
                
            }catch let error as NSError{
                print("fetchEscapesDataFromRealm error : \(error.userInfo)")
            }
        }
    }
    
    
    func reloadTableView(_ data: [MyAccountEscapeItem], escape_type: ProfileListType) {
        
        if (self.escapeType == escape_type) {
            
            tableDataArray = []
            tableDataArray = data
            tableView.reloadData()
        }
        
    }
    func receivedNotification(_ notification: Notification){
        if let dict = notification.object as? [String:AnyObject]{
            if let _ = dict["error"] as? String{
                errorInGettingEscapes()
                
            }else{
                if let type =  dict["type"] as? String{
                    if let data = dict["data"] as? [MyAccountEscapeItem]{
                        if let escapeType = ProfileListType(rawValue: type){
                            self.reloadTableView(data, escape_type: escapeType)
                        }
                    }
                }
            }
        }
        
    }
    func errorInGettingEscapes(){
        
    }
    
}



extension CustomListViewController : UITableViewDataSource , UITableViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY < lastContentOffsetY {
            if contentOffsetY < 0 {
                if let parentReference = parentReference {
                    parentReference.enableChildScrolls(false)
                    parentReference.mainScrollView.isScrollEnabled = true
                    parentReference.mainScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
                }
            }
        }
        
        lastContentOffsetY = scrollView.contentOffset.y
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCellIdentifier") as! CustomListTableViewCell
        cell.cellTitleLabel.text = tableDataArray[indexPath.row].title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else{
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CustomListTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension CustomListViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if tableDataArray.count > collectionView.tag{
            if let data = tableDataArray[collectionView.tag].escapeData{
                if data.count > 0 {
                    let id = data[indexPath.row].id
                    let escapeType = data[indexPath.row].escapeType
                    let name = data[indexPath.row].name
                    let image = data[indexPath.row].image
                    
                    var params : [String:Any] = [:]
                    if let id = id{
                        params["id"] = id
                    }
                    if let escapeType = escapeType{
                        params["escape_type"] = escapeType.rawValue
                    }
                    if let name = name{
                        params["name"] = name
                    }
                    if let image = image{
                        params["image"] = image
                    }
                    
                    ScreenVader.sharedVader.performScreenManagerAction(.OpenItemDescription, queryParams: params)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let data = tableDataArray[collectionView.tag].escapeData{
            count = data.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItemCollectionViewCell", for: indexPath) as! CustomListCollectionViewCell
        
        if let item = tableDataArray[collectionView.tag].escapeData{
            
            
        }
        
        return cell
    }
}


