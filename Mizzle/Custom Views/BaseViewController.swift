//
//  BaseViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 11/08/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let gai = AnalyticsVader.sharedVader.gaInstance {
            
            guard let tracker = gai.defaultTracker else { return }
            tracker.set(kGAIScreenName, value: getName())
            
            guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
            tracker.send(builder.build() as [NSObject : AnyObject])
        }
    }
    
    
    func getName() -> String {
        return className
    }
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
