//
//  EditEscapeViewController.swift
//  Escape
//
//  Created by Rahul Meena on 08/04/17.
//  Copyright © 2017 EscapeApp. All rights reserved.
//

import UIKit

protocol EditEscapeProtocol:class {
    
    func didDeleteEscape()
}

class EditEscapeViewController: UIViewController {
    
    @IBOutlet weak var escapeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    
    @IBOutlet weak var actionButton1: UIButton!
    @IBOutlet weak var actionButton2: UIButton!
    @IBOutlet weak var actionButton3: UIButton!
    
    var actionsToDisplay:[EscapeAddActions]!
    var presentingVC: UIViewController?
    var presentedVCObj : CustomPopupPresentationController?
    var queryParams : [String:Any]?
    
    weak var delegate: EditEscapeProtocol?
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var actionButtons:[UIButton]!
    var selectedAction: EscapeAddActions?
    
    var id: String!
    var name:String = ""
    var director:String = ""
    var image: String?
    var type : EscapeType = .Movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setParms()
        
        if type == .Books {
            actionsToDisplay = [.Reading, .ToRead, .Read]
        } else {
            actionsToDisplay = [.Watching, .ToWatch, .Watched]
        }
        actionButton1.setTitle(actionsToDisplay[0].rawValue, for: .normal)
        actionButton2.setTitle(actionsToDisplay[1].rawValue, for: .normal)
        actionButton3.setTitle(actionsToDisplay[2].rawValue, for: .normal)
        
        actionButtons = [actionButton1, actionButton2, actionButton3]
        
        setActionButtonStyle()
        
        setVisuals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading()
        fetchActionForEscape()
    }
    
    func setActionButtonStyle() {
        for actionButton in actionButtons {
            actionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            actionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        }
        
        actionButton1.isSelected = true
    }
    
    func hideShowActionButtons(hide: Bool) {
        
        for actionButton in actionButtons {
            actionButton.isHidden = hide
        }
    }
    
    func startLoading() {
        hideShowActionButtons(hide: true)
        activityIndicator.startAnimating()
        
        updateButton.isEnabled = false
    }
    
    func fetchActionForEscape() {
        
        MyAccountDataProvider.sharedDataProvider.escapeActionDelegate = self
        MyAccountDataProvider.sharedDataProvider.getActionForEscape(escapeId: self.id)
    }
    
    func stopLoading() {
        hideShowActionButtons(hide: false)
        activityIndicator.stopAnimating()
        
        updateButton.isEnabled = true
        
    }
    
    func updateActionButtons() {
        
        for (index, action) in actionsToDisplay.enumerated() {
            actionButtons[index].isSelected = false
            if let selectedAction = self.selectedAction {
                if selectedAction == action {
                    actionButtons[index].isSelected = true
                }
            }
        }
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        self.selectedAction = actionsToDisplay[sender.tag]
        updateActionButtons()
    }
    
    @IBAction func didTapOnUpdateButton(_ sender: UIButton) {
        if let selectedAction = self.selectedAction {
            MyAccountDataProvider.sharedDataProvider.updateEscape(escapeId: self.id, escapeAction: selectedAction)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapOnRemoveButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Remove Escape?", message: "Are you sure you want to remove \"\(self.name)\" from your Escape's?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            MyAccountDataProvider.sharedDataProvider.removeEscape(escapeId: self.id)
            if let delegate = self.delegate {
                delegate.didDeleteEscape()
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setParms(){
        
        if let params = queryParams {
            
            if let delegate = params["delegate"] as? EditEscapeProtocol {
                self.delegate = delegate
            }
            
            if let escapeId = params["escape_id"] as? String {
                self.id = escapeId
            }
            
            if let escapeType = params["escape_type"] as? EscapeType {
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
                if let type = data.discoverType, let escapeType = EscapeType(rawValue: type.rawValue) {
                    self.type = escapeType
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
                if let type = data.searchType, let escapeType = EscapeType(rawValue: type.rawValue){
                    self.type = escapeType
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
        
        if type == .Books {
            
            directorLabel.text = "Author:"
            
        } else if type == .TvShows {
            directorLabel.text = "Creator:"
        }
        
        
    }
    
}

extension EditEscapeViewController: EscapeActionProtocol {
    func receivedActionForEscape(escapeId: String, escapeAction: EscapeAddActions) {
        self.selectedAction = escapeAction
        updateActionButtons()
        stopLoading()
    }
    
    func failedToFetchAction() {
        
    }
}

extension EditEscapeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: 310, height: 430, yOffset: self.view.frame.size.height/2-215, cornerRadius : 5)
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

