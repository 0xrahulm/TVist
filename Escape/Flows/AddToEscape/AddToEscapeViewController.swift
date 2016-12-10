//
//  AddToEscapeViewController.swift
//  Escape
//
//  Created by Ankit on 09/07/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

protocol AddToEscapeDoneProtocol : class {
    func doneButtonTapped()
}

class AddToEscapeViewController: UIViewController {
    
    weak var addToEscapeDoneDelegate : AddToEscapeDoneProtocol?
    
    var presentingVC: UIViewController?
    var queryParams : [String:AnyObject]?
    
    var id : String?
    var name = ""
    var director = ""
    var image : String?
    var type : String?
    
    @IBOutlet weak var escapeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareFBSwitch: UISwitch!
    
    @IBOutlet weak var tagFriendsView: UIView!
    
    var currentSelectedView : EscapeAddActions = .ToWatch
    
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setParms()
        setVisuals()
        
        
    }
    
    func setParms(){
        
        if let params = queryParams{
            if let delegate = params["delegate"] as? UITableViewCell{
                if let searchVCDelegate = delegate as? SearchTableViewCell {
                    addToEscapeDoneDelegate = searchVCDelegate
                }
                
                if let discoverVCCell = delegate as? DiscoverEscapeTableViewCell {
                    addToEscapeDoneDelegate = discoverVCCell
                }
                
            }
            
            if let data = params["data"] as? DiscoverItems{
                if let id = data.id{
                    self.id = id
                }
                if let name = data.name{
                    self.name = name
                }
                if let director = data.director{
                    self.director = director
                }
                if let image = data.image{
                    self.image = image
                }
                if let type = data.discoverType{
                    self.type = type.rawValue
                }
                
            }else if let data = params["data"] as? SearchItems{
                
                if let id = data.id{
                    self.id = id
                }
                if let name = data.name{
                    self.name = name
                }
                if let director = data.director{
                    self.director = director
                }
                if let image = data.image{
                    self.image = image
                }
                if let type = data.searchType{
                    self.type = type.rawValue
                }
                
            }
            
        }
        
    }
    
    func setVisuals(){
        
        if let image  = image{
            escapeImage.downloadImageWithUrl(image, placeHolder: nil)
        }else{
            escapeImage.image = UIImage(named: "movie_placeholder")
        }
        
        titleLabel.text = self.name
        directorNameLabel.text = self.director
        
        
        
        if type == "book"{
            currentSelectedView = .ToRead
            segmentController.setTitle("To Read", forSegmentAtIndex: 0)
            segmentController.setTitle("Read", forSegmentAtIndex: 1)
            segmentController.setTitle("Reading", forSegmentAtIndex: 2)
            directorLabel.text = "Author:"
            //tagFriendsView.hidden = true
            
        }
        
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Add your comment"
        if let font = textView.font{
            placeholderLabel.font = UIFont.italicSystemFontOfSize(font.pointSize)
        }
        
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        if let font = textView.font{
            placeholderLabel.frame.origin = CGPointMake(5, font.pointSize / 2)
        }
        
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = !textView.text.isEmpty
        
        
    }
    
    @IBAction func tagPeopleTapped(sender: UITapGestureRecognizer) {
        
        let storyBoard = UIStoryboard(name: "MyAccount", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("friendsVC") as! FriendsViewController
        
        vc.freindsDelegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //ScreenVader.sharedVader.performScreenManagerAction(.OpenFriendsView, queryParams: nil)
        
        
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        //UserDataProvider.sharedDataProvider.addToEscape(data.id, action: currentSelectedView, status : textView.text)
        if addToEscapeDoneDelegate != nil{
            addToEscapeDoneDelegate?.doneButtonTapped()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

extension AddToEscapeViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: 310, height: 400, yOffset: 0, cornerRadius : 5)
        return presentationController;
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: false)
    }
}
extension AddToEscapeViewController : UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = !textView.text.isEmpty
    }
}
extension AddToEscapeViewController : FriendsProtocol{
    func taggedFriendIds(ids : [String]){
        
    }
}
