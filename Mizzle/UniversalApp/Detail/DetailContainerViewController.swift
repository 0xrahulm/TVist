//
//  DetailContainerViewController.swift
//  TVist
//
//  Created by Rahul Meena on 28/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class DetailContainerViewController: UIViewController {

    fileprivate var _mainViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var viewControllers: [UIViewController]  {
        get {
            let immutableCopy = _mainViewControllers
            return immutableCopy
        }
        set {
            _mainViewControllers = newValue
        }
    }
    
    var activeViewController: UIViewController? {
        didSet {
//            changeActiveViewControllerFrom(oldValue)
        }
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
