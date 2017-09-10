//
//  PageContentViewController.swift
//  Escape
//
//  Created by Ankit on 21/04/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var pageIndex : Int?
    var imageFile : String?
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageFile = imageFile{
            if let foundImage = UIImage(named: imageFile) {
                self.image.image = foundImage
            }
        }
        self.label.text = self.text
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
