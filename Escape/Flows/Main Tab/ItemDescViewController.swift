//
//  ItemDescViewController.swift
//  Escape
//
//  Created by Ankit on 21/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit

class ItemDescViewController: UIViewController {
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemTitle:       UILabel!
    @IBOutlet weak var itemSubTitle:    UILabel!
    @IBOutlet weak var yearTitle:       UILabel!
    @IBOutlet weak var yearLabel:       UILabel!
    @IBOutlet weak var ratingTitle:     UILabel!
    @IBOutlet weak var ratingLabel:     UILabel!
    @IBOutlet weak var runTimeTitle:    UILabel!
    @IBOutlet weak var runTimeLabel:    UILabel!
    @IBOutlet weak var DirectorLabel:   UILabel!
    @IBOutlet weak var castLabel:       UILabel!
    @IBOutlet weak var generesLabel:    UILabel!
    @IBOutlet weak var descLabel:       UILabel!
    
    var escapeType : EscapeType! //required Field
    var id : String! // required Field
    var name : String?
    var image: String?
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        if let type = queryParams["escapeType"] as? String{
            escapeType = EscapeType(rawValue: type)
        }
        if let idToFetch = queryParams["id"] as? String{
            id = idToFetch
        }
        if let itemName = queryParams["name"] as? String{
            name = itemName
        }
        if let itemImage = queryParams["image"] as? String{
            image = itemImage
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.title = name
        }
        if let image = image{
            itemImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "movie_placeholder"))
            
        }
        MyAccountDataProvider.sharedDataProvider.itemDescDelegate = self
        MyAccountDataProvider.sharedDataProvider.getItemDesc(escapeType, id: id)

       
    }
    func fillData(descData : DescDataItems?){
        if let descData = descData {
            if let name = descData.name{
                itemTitle.text = name
            }
            if let subtitle = descData.subtitle{
                itemSubTitle.text = subtitle
            }
            if let image = descData.image{
                itemImage.downloadImageWithUrl(image, placeHolder: UIImage(named: "movie_placeholder"))
            }
            if let year = descData.releaseDate{
                yearTitle.text = "Released In"
                yearLabel.text = "\(TimeUtility.getYear(year))"
                
            }
            if let rating = descData.rating{
                ratingTitle.text = "Rating"
                var outOf = " / 10"
                if escapeType == .Books{
                    outOf = " / 5"
                }
                ratingLabel.text = "\(rating)\(outOf)"
            }
            if let runtime = descData.runtime{
                runTimeTitle.text = "Runtime"
                runTimeLabel.text = runtime
            }
            if let director = descData.director{
                var text = "Directed by"
                if escapeType == .Books{
                    text = "Author"
                }
                DirectorLabel.attributedText = getString(text, str: director)
            }
            if let cast = descData.cast{
                castLabel.attributedText = getString("Cast", str: cast)
            }
            if descData.generes.count > 0{
                var gerenes = ""
                var i = 0
                for gen in descData.generes{
                    if i == 0{
                        gerenes = gerenes + gen
                    }else{
                        gerenes = gerenes + ", \(gen)"
                    }
                    i = i + 1
                }
                generesLabel.attributedText = getString("Generes", str: gerenes)
                
            }
            if let desc = descData.desc{
                descLabel.attributedText = getString("Description", str: desc)
            }
            
            
        }
        
    }
    func getString(title : String , str : String) -> NSAttributedString{
        
        let titleString = SFUIAttributedText.mediumAttributedTextForString("\(title) : ", size: 16, color: UIColor.textBlackColor())
        
        let descString = SFUIAttributedText.regularAttributedTextForString(str, size: 14, color: UIColor.textGrayColor())
        
        let attributedString = NSMutableAttributedString()
        attributedString.appendAttributedString(titleString)
        attributedString.appendAttributedString(descString)
        return attributedString
    }
}
extension ItemDescViewController : ItemDescProtocol{
    func receivedItemDesc(data: DescDataItems?) {
        fillData(data)
        
    }
    func errorItemDescData() {
        
    }
}
