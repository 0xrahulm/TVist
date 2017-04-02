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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ScreenVader.sharedVader.hideTabBar(true)
        
        self.navigationController?.isNavigationBarHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeCommentViewController.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeCommentViewController.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        commentTextField.becomeFirstResponder()
    }
    
    func getComments(){
        if let storyId = storyId{
            HomeDataProvider.sharedDataProvider.getStoryComments(storyId)
        }
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                doneButtonChangeBottomConstantWithAnimation(keyboardFrame.cgRectValue.height)
            }
        }
        
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        doneButtonChangeBottomConstantWithAnimation(0)
    }
    
    func doneButtonChangeBottomConstantWithAnimation(_ constant: CGFloat) {
        commentBottomConstraint.constant = constant
        layoutWithAnimation()
    }
    
    func layoutWithAnimation() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension HomeCommentViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "commentCellIdentifier") as? CommentTableViewCell
        cell.data = commentDataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDataArray.count
    }
}
extension HomeCommentViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !firstTimeScroll{
            commentTextField.resignFirstResponder()
        }
    }
}
extension HomeCommentViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
    func recievedStoryComment(_ comments: [StoryComment], storyId: String) {
        
        if self.storyId == storyId{
            self.commentDataArray = comments
            tableView.reloadData()
            
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HomeCommentViewController.scrollToBottom), userInfo: nil , repeats: false)
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
        let indexPath = IndexPath(item: commentDataArray.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        _ = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(HomeCommentViewController.firstTimeScrollFalse), userInfo: nil , repeats: false)
        
        
    }
    func firstTimeScrollFalse()  {
        firstTimeScroll = false
    }
}
