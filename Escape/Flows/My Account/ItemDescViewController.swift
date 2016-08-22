//
//  ItemDescViewController.swift
//  Escape
//
//  Created by Ankit on 21/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import ionicons

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
    
    @IBOutlet weak var addEscapeButton: UIButton!
    
    private var popover: Popover!
    
    var optionsArray : [OptionsType] = [.Add , .Recommend]
    var popOverHeight : CGFloat = 90
    var escapeAlreadyAdded = false
    
    
    private var popoverOptions: [PopoverOption] = [
        .Type(.Down),
        .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        MyAccountDataProvider.sharedDataProvider.itemDescDelegate = self
        MyAccountDataProvider.sharedDataProvider.getItemDesc(escapeType, id: id)

       
    }
    func setVisuals(){
        let settingImage = IonIcons.imageWithIcon(ion_android_options, size: 30, color: UIColor.whiteColor())
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ItemDescViewController.optionsTapped))
        
        self.navigationItem.rightBarButtonItem = settingButton
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
                
            }else if let yearRange = descData.yearRange{
                yearTitle.text = "Year"
                yearLabel.text = yearRange
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
                }else if escapeType == .TvShows{
                    text = "Creator"
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
           
            escapeAlreadyAdded  = descData.isActed

            setVisuals()
            
            if descData.isActed{
                addEscapeButton.hidden = true
            }else{
                addEscapeButton.hidden = false
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
    
    
    @IBAction func addEscapeTapped(sender: AnyObject) {
        
        
    }
    func optionsTapped(){
        if escapeAlreadyAdded{
            optionsArray = [.Edit , .Delete , .Recommend]
            popOverHeight = 135
        }
        
        let viewX = UIView(frame: CGRect(x: self.view.frame.width - 30, y: 65, width: 0, height: 0))
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: popOverHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.separatorColor = UIColor.clearColor()
        self.popover = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)
        self.popover.show(tableView, fromView: viewX)
        
    }
    
}
extension ItemDescViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.popover.dismiss()
        
        if optionsArray[indexPath.row] == .Recommend{
            if let escapeId = self.id{
                ScreenVader.sharedVader.performScreenManagerAction(.OpenFollowers, queryParams: ["userType": UserType.Friends.rawValue, "escape_id" : escapeId])
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return optionsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text =  optionsArray[indexPath.row].rawValue
        
        if(indexPath.row != self.optionsArray.count-1){
            let line = UIView(frame: CGRect(x: 0, y: 44, width: tableView.frame.width, height: 1))
            line.backgroundColor = UIColor.groupTableViewBackgroundColor()
            cell.addSubview(line)
        
        }
        return cell
    }
}

extension ItemDescViewController : ItemDescProtocol{
    
    func receivedItemDesc(data: DescDataItems?, id : String) {
        
            if self.id == id{
                fillData(data)
            }
    }
    
    func errorItemDescData() {
        
    }
}
