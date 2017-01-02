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
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var visualEffectsLayer: UIVisualEffectView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var itemTitle:       UILabel!
    @IBOutlet weak var yearLabel:       UILabel!
    @IBOutlet weak var ratingLabel:     UILabel!
    @IBOutlet weak var runTimeLabel:    UILabel!
    @IBOutlet weak var creatorTypeLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var castDetailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //    @IBOutlet weak var addEscapeButton: UIButton!
    
    let offset_HeaderStop:CGFloat = 100.0 // At this offset the Header stops its transformations
    let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
    let distance_W_LabelHeader:CGFloat = 35.0
    
    private var popover: Popover!
    
    var optionsArray: [OptionsType] = [.Add , .Recommend]
    var popOverHeight: CGFloat = 90
    var escapeAlreadyAdded = false
    
    
    private var popoverOptions: [PopoverOption] = [
        .Type(.Down),
        .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    var escapeItem: EscapeItem!
    
    // For Custom Present Animation
    let customPresentAnimationController = CustomPresentAnimationController()
    
    override func setObjectsWithQueryParameters(queryParams: [String : AnyObject]) {
        if let escapeItem = queryParams["escapeItem"] as? EscapeItem {
            self.escapeItem = escapeItem
        }
        
        if let escapeId = queryParams["escape_id"] as? String{
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let escapeType = escapeItem.escapeTypeVal()
        let escapeId   = escapeItem.id
        
        MyAccountDataProvider.sharedDataProvider.itemDescDelegate = self
        MyAccountDataProvider.sharedDataProvider.getItemDesc(escapeType, id: escapeId)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ScreenVader.sharedVader.hideTabBar(true)
        ScreenVader.sharedVader.changeStatusBarPreference(false)
        
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setEscapeDetails(escapeItem.name, subtitle: nil, year: escapeItem.year, image:escapeItem.posterImage, rating: escapeItem.rating)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ScreenVader.sharedVader.changeStatusBarPreference(true)
        
        setNeedsStatusBarAppearanceUpdate()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setVisuals(){
        let settingImage = IonIcons.imageWithIcon(ion_android_options, size: 30, color: UIColor.whiteColor())
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ItemDescViewController.optionsTapped))
        
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    func setEscapeDetails(name: String, subtitle: String?, year: String?, image: String?, rating: String?) {
        
        if let subtitle = subtitle {
            itemTitle.text = name+" - "+subtitle
        } else {
            itemTitle.text = name
        }
        
        headerLabel.text = name
        
        if let yearText = year {
            yearLabel.text = yearText
        }
        
        
        if let image = image {
            itemImage.downloadImageWithUrl(image , placeHolder: UIImage(named: "movie_placeholder"))
            
            headerImage.downloadImageWithUrl(image, placeHolder: nil)
            
        }
        
        if let rating = rating {
            ratingLabel.text = "\(rating)"
        }
        
    }
    
    func fillData(descData : DescDataItems?){
        
        if let descData = descData {
            
            
            
            if let image = descData.image{
                itemImage.downloadImageWithUrl(image, placeHolder: UIImage(named: "movie_placeholder"))
            }
            
            if let runtime = descData.runtime{
                runTimeLabel.text = runtime
            }
            if let createdBy = descData.createdBy {
                var text = "Directed by"
                if escapeItem.escapeTypeVal() == .Books {
                    text = "Author"
                }else if escapeItem.escapeTypeVal() == .TvShows {
                    text = "Creator"
                }
                creatorTypeLabel.text = text
                creatorLabel.text = createdBy
            }
            if let cast = descData.cast{
                castDetailLabel.text = cast
            } else {
                castDetailLabel.text = nil
                castLabel.text = nil
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
                //                generesLabel.attributedText = getString("Generes", str: gerenes)
                
            }
            if let desc = descData.desc{
                descriptionLabel.text = desc
            }
            
            escapeAlreadyAdded  = descData.isActed
            
            setVisuals()
            
            if descData.isActed{
                //                addEscapeButton.hidden = true
            }else{
                //                 addEscapeButton.hidden = false
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
    
    @IBAction func dismissViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
            let escapeId = escapeItem.id
            
            ScreenVader.sharedVader.performScreenManagerAction(.OpenFollowers, queryParams: ["userType": UserType.Friends.rawValue, "escape_id" : escapeId])
            
            
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
    
    func receivedItemDesc(data: DescDataItems?, id: String) {
        fillData(data)
    }
    
    func errorItemDescData() {
        
    }
}

extension ItemDescViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        var imageTransform  = CATransform3DIdentity
        // Pull Down
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerView.layer.transform = headerTransform
        }
            // SCROLL UP/DOWN ------------
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            let blurOffset = offset/offset_HeaderStop
            if offset > 0 && blurOffset < 1.01 {
                visualEffectsLayer.alpha = max(0.7, blurOffset)
            }
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / itemImage.bounds.height / 1.8 // Slow down the animation
            let avatarSizeVariation = ((itemImage.bounds.height * (1.0 + avatarScaleFactor)) - itemImage.bounds.height) / 2.0
            imageTransform = CATransform3DTranslate(imageTransform, 0, avatarSizeVariation, 0)
            imageTransform = CATransform3DScale(imageTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if itemImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                    headerLabel.layer.zPosition = 0
                }
                
            }else {
                if itemImage.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 1
                    headerLabel.layer.zPosition = 2
                }
            }
        }
        
        
        // Apply Transformations
        
        headerView.layer.transform = headerTransform
        itemImage.layer.transform = imageTransform
        
    }
}
