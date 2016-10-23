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
    var id : String!
    var type : DiscoverType!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var toWatchlabel: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var watchingLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    var currentSelectedView : EscapeAddActions = .ToWatch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .Books{
            currentSelectedView = .ToRead
            toWatchlabel.text = "To Read"
            watchingLabel.text = "Reading"
            watchedLabel.text = "Read"
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        UserDataProvider.sharedDataProvider.addToEscape(id, action: currentSelectedView, status : textView.text)
        if addToEscapeDoneDelegate != nil{
            addToEscapeDoneDelegate?.doneButtonTapped()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view{
            if view.tag == 1{
                leftView.backgroundColor = UIColor.escapeBlueColor()
                centerView.backgroundColor = UIColor.viewSelectedColor()
                rightView.backgroundColor = UIColor.viewSelectedColor()
                
                toWatchlabel.textColor = UIColor.whiteColor()
                watchedLabel.textColor = UIColor.textLightGrayColor()
                watchingLabel.textColor = UIColor.textLightGrayColor()
                
                if type == .TvShows || type == .Movie{
                    currentSelectedView = .ToWatch
                }else if type == .Books{
                    currentSelectedView = .ToRead
                }
                
            }else if view.tag == 2{
                leftView.backgroundColor = UIColor.viewSelectedColor()
                centerView.backgroundColor = UIColor.escapeBlueColor()
                rightView.backgroundColor = UIColor.viewSelectedColor()
                
                toWatchlabel.textColor = UIColor.textLightGrayColor()
                watchedLabel.textColor = UIColor.whiteColor()
                watchingLabel.textColor = UIColor.textLightGrayColor()
                
                if type == .TvShows || type == .Movie{
                    currentSelectedView = .Watched
                }else if type == .Books{
                    currentSelectedView = .Read
                }
                
            }else if view.tag == 3{
                leftView.backgroundColor = UIColor.viewSelectedColor()
                centerView.backgroundColor = UIColor.viewSelectedColor()
                rightView.backgroundColor = UIColor.escapeBlueColor()
                
                toWatchlabel.textColor = UIColor.textLightGrayColor()
                watchedLabel.textColor = UIColor.textLightGrayColor()
                watchingLabel.textColor = UIColor.whiteColor()
                
                if type == .TvShows || type == .Movie{
                    currentSelectedView = .Watching
                }else if type == .Books{
                    currentSelectedView = .Reading
                }
            }
        }
    }
    
}

extension AddToEscapeViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPopupPresentationController(presentedViewController: presented, presentingViewController: presentingVC!, width: 300, height: 190, yOffset: 60, cornerRadius : 0)
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
