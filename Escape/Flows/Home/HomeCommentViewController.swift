//
//  HomeCommentViewController.swift
//  Escape
//
//  Created by Ankit on 19/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class HomeCommentViewController: UIViewController {
    
    var storyId : String?
    var commentDataArray : [StoryComment] = []
    var firstTimeScroll = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Comments"
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
        
        postButton.alpha = 0.4
        
        commentTextField.delegate = self
        
        HomeDataProvider.sharedDataProvider.storyCommentDelegate = self
        
        getComments()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(true)
        
        self.navigationController?.navigationBarHidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeCommentViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeCommentViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        commentTextField.becomeFirstResponder()
    }
    
    func getComments(){
        if let storyId = storyId{
            HomeDataProvider.sharedDataProvider.getStoryComments(storyId)
        }
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                doneButtonChangeBottomConstantWithAnimation(keyboardFrame.CGRectValue().height)
            }
        }
        
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        doneButtonChangeBottomConstantWithAnimation(0)
    }
    
    func doneButtonChangeBottomConstantWithAnimation(constant: CGFloat) {
        commentBottomConstraint.constant = constant
        layoutWithAnimation()
    }
    
    func layoutWithAnimation() {
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        
        
        if let comment = commentTextField.text{
            if comment != ""{
                if let storyId = storyId{
                    HomeDataProvider.sharedDataProvider.postStoryComments(storyId, comment: comment)
                }
                commentTextField.resignFirstResponder()
            }
        }
        
        commentTextField.text = ""
    }
    
}
extension HomeCommentViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension HomeCommentViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CommentTableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier("commentCellIdentifier") as? CommentTableViewCell
        cell.data = commentDataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDataArray.count
    }
}
extension HomeCommentViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !firstTimeScroll{
            commentTextField.resignFirstResponder()
        }
    }
}
extension HomeCommentViewController : UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string == ""{
            postButton.alpha = 0.4
        }else{
            postButton.alpha = 1
        }

        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 200
    }
}
extension HomeCommentViewController : HomeStoryCommentProtocol{
    func recievedStoryComment(comments: [StoryComment], storyId: String) {
        
        if self.storyId == storyId{
            self.commentDataArray = comments
            tableView.reloadData()
            
            _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(HomeCommentViewController.scrollToBottom), userInfo: nil , repeats: false)
        }
        
    }
    func error() {
        
    }
    func postStoryCommentSuccess(){
        getComments()
        
    }
    func errorPostComment(){
        
    }
    
    func scrollToBottom(){
        let indexPath = NSIndexPath(forItem: commentDataArray.count-1, inSection: 0)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(HomeCommentViewController.firstTimeScrollFalse), userInfo: nil , repeats: false)
        
        
    }
    func firstTimeScrollFalse()  {
        firstTimeScroll = false
    }
}
