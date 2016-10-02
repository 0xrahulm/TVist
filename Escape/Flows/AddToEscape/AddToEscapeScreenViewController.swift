//
//  AddToEscapeScreenViewController.swift
//  Escape
//
//  Created by Ankit on 25/09/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class AddToEscapeScreenViewController: UIViewController {
    
    @IBOutlet weak var watchingButton: UIButton!
    @IBOutlet weak var toWatchButton: UIButton!
    @IBOutlet weak var watchedButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchingButton.selectedTrueForCollection()
        toWatchButton.selectedFalseForCollection()
        watchedButton.selectedFalseForCollection()
        
        collectionView.reloadData()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
extension AddToEscapeScreenViewController : UICollectionViewDelegate{
    
}
extension AddToEscapeScreenViewController : UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tagPeopleCellIdentifier", forIndexPath: indexPath) as! TagPeopleCollectionViewCell
        cell.cellImage.image = UIImage(named: "movie_placeholder")
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
}
