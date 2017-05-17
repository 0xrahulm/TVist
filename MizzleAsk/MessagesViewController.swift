//
//  MessagesViewController.swift
//  MizzleAsk
//
//  Created by Rahul Meena on 10/05/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import Messages

enum ExtensionViewControllerIdentifier:String {
    case SelectOptionVC="selectOptionVC"
    case SearchViewVC="SearchVC"
}

class MessagesViewController: MSMessagesAppViewController {
    
    var searchShouldOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        removeAllChildViewControllers()
        
        
        // Determine the controller to present.
        var controller: UIViewController
        
        let type:String? = MessageFactory.getSearchTypeWithConversation(conversation: conversation)
        
        
        if let _ = type {
            searchShouldOpen = true
        }
        
        if searchShouldOpen {
            // Show a list of previously created ice creams.
            controller = instantiateSearchViewController(type: type)
        }
        else {
            controller = initializeSelectOptionVC()
            /*
             Parse an `IceCream` from the conversation's `selectedMessage` or
             create a new `IceCream` if there isn't one associated with the message.
//             */
//            let iceCream = IceCream(message: conversation.selectedMessage) ?? IceCream()
//            
//            if iceCream.isComplete {
//                controller = instantiateCompletedIceCreamController(with: iceCream)
//            }
//            else {
//                controller = instantiateBuildIceCreamController(with: iceCream)
//            }
        }
        
        addViewControllerAsChild(controller: controller)
    }
    
    func presentSearchVC() {
        self.searchShouldOpen = true
        requestPresentationStyle(.expanded)
    }
    
    func addViewControllerAsChild(controller: UIViewController) {
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    func instantiateSearchViewController(type: String?) -> SearchViewController {
        guard let searchViewVC = initializeVC(with: .SearchViewVC) as? SearchViewController else {
            fatalError("Cannot instantiate searchViewVC")
        }
        searchViewVC.delegate = self
        searchViewVC.setMoveToIndexWithType(type: type)
        return searchViewVC
    }
    
    func initializeSelectOptionVC() -> SelectOptionViewController {
        guard let selectOptionVC = initializeVC(with: .SelectOptionVC) as? SelectOptionViewController else {
            fatalError("Cannot instantiate SelectOptionVC")
        }
        selectOptionVC.delegate = self
        
        return selectOptionVC
    }
    
    func initializeVC(with identifier: ExtensionViewControllerIdentifier) -> UIViewController {
        
        guard let anyVC = self.storyboard?.instantiateViewController(withIdentifier: identifier.rawValue) else {
            fatalError("Cannot instantiate VC with identifier \(identifier.rawValue)")
        }
        
        return anyVC
    }
    
    
    // MARK: Convenience
    
    private func removeAllChildViewControllers() {
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    // MARK: - Send or Receive Messages
    
    func sendMessage(message: MSMessage) {
        if let conversation = activeConversation {
            conversation.insert(message, completionHandler: { (error) in
                if let error = error {
                    Logger.debug("Could not insert mssage: \(error.localizedDescription)")
                }
            })
        }
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        removeAllChildViewControllers()
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    }

    
    
}

extension MessagesViewController: SearchViewControllerDelegate {
    func didTapOnCancelButton() {
        self.searchShouldOpen = false
        requestPresentationStyle(.compact)
    }
    
    func didTapOnSearchItem(searchItem: SearchItems, loadedImage:UIImage?) {
        requestPresentationStyle(.compact)
        self.searchShouldOpen = false
        let message = MessageFactory.createMediaItemMessage(searchItem: searchItem, loadedImage: loadedImage)
        sendMessage(message: message)
    }
    
    func didTapOnSearch() {
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: SelectOptionViewControllerDelegate {
    func didTapOnSearchButton() {
        presentSearchVC()
    }
    
    func didTapOnSuggestionButton(type: SearchType) {
        if presentationStyle == .expanded {
            requestPresentationStyle(.compact)
        }
        let message = MessageFactory.createAskSuggestionMessage(type: type)
        sendMessage(message: message)
    }
}
