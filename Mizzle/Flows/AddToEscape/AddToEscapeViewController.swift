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
    var presentedVCObj : CustomPopupPresentationController?
    var queryParams : [String:Any]?
    
    var id : String?
    var name = ""
    var director = ""
    var image : String?
    var type : String?
    var friendsIds : [String] = []
    
    @IBOutlet weak var escapeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareFBSwitch: UISwitch!
    
    @IBOutlet weak var tagFriendsView: UIView!
    
    @IBOutlet weak var actionButton3: UIButton!
    @IBOutlet weak var actionButton2: UIButton!
    @IBOutlet weak var actionButton1: UIButton!
    
    var currentSelectedView : EscapeAddActions = .ToWatch
    
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setParms()
        setVisuals()
        addDoneButtonOnKeyboard()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let id = self.id, let type = self.type {
            
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddToEscapeViewController.doneButtonAction))
        
        var items : [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textView.inputAccessoryView = doneToolbar

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
            
            if let delegate = params["delegate"] as? AddToEscapeDoneProtocol {
                addToEscapeDoneDelegate = delegate
            }
            
            
            if let escapeId = params["escape_id"] as? String {
                self.id = escapeId
            }
            
            if let escapeType = params["escape_type"] as? EscapeType {
                self.type = escapeType.rawValue
            }
            
            if let escapeType = params["escape_type"] as? String {
                self.type = escapeType
            }
            
            if let escapeImageUri = params["escape_image"] as? String {
                self.image = escapeImageUri
            }
            
            if let escapeName = params["escape_name"] as? String {
                self.name = escapeName
            }
            
            if let director = params["createdBy"] as? String {
                self.director = director
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
        self.peopleLabel.text = ""
        actionButton1.isSelected = false
        actionButton2.isSelected = false
        actionButton3.isSelected = true
        
        actionButton1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        actionButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        actionButton2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        actionButton2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        actionButton3.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        actionButton3.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        
        if let type = self.type {
            
            if type == "book"{
                currentSelectedView = .Read
//                segmentController.setTitle("To Read", forSegmentAt: 0)
//                segmentController.setTitle("Read", forSegmentAt: 1)
//                segmentController.setTitle("Reading", forSegmentAt: 2)
                directorLabel.text = "Author:"
                actionButton1.setTitle("Reading", for: .normal)
                actionButton2.setTitle("To Read", for: .normal)
                actionButton3.setTitle("Read", for: .normal)
                
                
            } else {
                currentSelectedView = .Watched
                
                actionButton1.setTitle("Watching", for: .normal)
                actionButton2.setTitle("To Watch", for: .normal)
                actionButton3.setTitle("Watched", for: .normal)
                
                if type == "tv_show" {
                    directorLabel.text = "Creator:"
                }
            }
        }
        
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Add your comment"
        if let font = textView.font{
            placeholderLabel.font = UIFont.italicSystemFont(ofSize: font.pointSize)
        }
        
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        if let font = textView.font{
            placeholderLabel.frame.origin = CGPoint(x: 5, y: font.pointSize / 2)
        }
        
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddToEscapeViewController.viewTapped(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        
    }
    @objc func viewTapped(_ tapRecognizer: UITapGestureRecognizer){
        self.textView.resignFirstResponder()
    }
    
    @IBAction func tagPeopleTapped(_ sender: UITapGestureRecognizer) {
        
        let storyBoard = UIStoryboard(name: "MyAccount", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "friendsVC") as! CustomNavigationViewController
        let rootVC = vc.viewControllers[0] as! FriendsViewController
        
        rootVC.freindsDelegate = self
        
        self.present(vc, animated: true, completion: nil)
        
        
        //ScreenVader.sharedVader.performScreenManagerAction(.OpenFriendsView, queryParams: nil)
        
        
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        
        if let id = id {
            
            if let type = self.type {
                
            }
            
            UserDataProvider.sharedDataProvider.addToEscape(id, action: currentSelectedView, status : textView.text,friendsId :  friendsIds, shareFB : shareFBSwitch.state.rawValue)
        }
        
        if addToEscapeDoneDelegate != nil{
            addToEscapeDoneDelegate?.doneButtonTapped()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            if type == "book"{
                currentSelectedView = .ToRead
            }else{
                currentSelectedView = .ToWatch
            }
            
        }else if sender.selectedSegmentIndex == 1{
            if type == "book"{
                currentSelectedView = .Read
            }else{
                currentSelectedView = .Watched
            }
            
        }else{
            if type == "book"{
                currentSelectedView = .Reading
            }else{
                currentSelectedView = .Watching
            }
            
        }
        
        self.textView.resignFirstResponder()
        
    }
  
    @IBAction func actionButton1Tapped(_ sender: UIButton) {
        actionButton1.isSelected = true
        actionButton2.isSelected = false
        actionButton3.isSelected = false
        if type == "book"{
            currentSelectedView = .Reading
        }else{
            currentSelectedView = .Watching
        }
        
    }
    
    @IBAction func actionButton2Tapped(sender: UIButton) {
        actionButton1.isSelected = false
        actionButton2.isSelected = true
        actionButton3.isSelected = false
        if type == "book"{
            currentSelectedView = .ToRead
        }else{
            currentSelectedView = .ToWatch
        }

    }
    
    @IBAction func actionButton3Tapped(sender: UIButton) {
        actionButton1.isSelected = false
        actionButton2.isSelected = false
        actionButton3.isSelected = true
        if type == "book"{
            currentSelectedView = .Read
        }else{
            currentSelectedView = .Watched
        }
    }
}

extension AddToEscapeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: 310, height: 420, yOffset: self.view.frame.size.height/2-220, cornerRadius : 5)
        presentedVCObj = presentationController
        return presentationController;
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed != self {
            return nil
        }
        return CustomPresentationAnimationViewController(isPresenting: false)
    }
}
extension AddToEscapeViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
extension AddToEscapeViewController : FriendsProtocol{
    func taggedFriendIds(_ ids : [String]){
        if ids.count > 0{
            self.peopleLabel.text = "\(ids.count) People"
        }
        
        self.friendsIds = ids
        
    }
}
