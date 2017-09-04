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
    
    @IBOutlet weak var ovalImage: UIImageView!
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var similarEscapesView: SimilarEscapesView!
    @IBOutlet weak var relatedPeopleView: RelatedPeopleView!
    
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
    
    @IBOutlet weak var runTimeImage: UIImageView!
    @IBOutlet weak var readMoreButton: UIButton!
    
    
    var escapeId:String?
    var escapeType:EscapeType?
    var imageUri: String?
    var escapeName: String?
    var createdBy: String?
    
    @IBOutlet weak var addEditEscapeButton: UIButton!
    
    let offset_HeaderStop:CGFloat = 100.0 // At this offset the Header stops its transformations
    let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
    let distance_W_LabelHeader:CGFloat = 35.0
    
    fileprivate var popover: Popover!
    
    var optionsArray: [OptionsType] = [.Add , .Recommend]
    var popOverHeight: CGFloat = 90
    var escapeAlreadyAdded:Bool = false
    
    
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    var escapeItem: EscapeItem?
    
    // For Custom Present Animation
    let customPresentAnimationController = CustomPresentAnimationController()
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        if let escapeItem = queryParams["escapeItem"] as? EscapeItem {
            self.escapeItem = escapeItem
        }
        
        if let escapeId = queryParams["escape_id"] as? String {
            self.escapeId = escapeId
        }
        
        if let escapeTypeName = queryParams["escape_type"] as? String, let escapeType = EscapeType(rawValue: escapeTypeName) {
            self.escapeType = escapeType
        }
        
        if let escapeId = queryParams["id"] as? String{
            self.escapeId = escapeId
        }
        
        if let escapeName = queryParams["name"] as? String {
            self.escapeName = escapeName
        }
        
        if let imageUri = queryParams["image"] as? String {
            self.imageUri = imageUri
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        addEditEscapeButton.isHidden = true
        MyAccountDataProvider.sharedDataProvider.itemDescDelegate = self
        
        if let escapeItem = self.escapeItem {
            self.escapeType = escapeItem.escapeTypeVal()
            self.escapeId   = escapeItem.id
            self.escapeName = escapeItem.name
            self.imageUri = escapeItem.posterImage
            
        }
        
        if let escapeId = self.escapeId {
            MyAccountDataProvider.sharedDataProvider.getItemDesc(self.escapeType, id: escapeId)
        }
        
        updateButtonStatus()
        self.similarEscapesView.viewAllTapDelegate = self
        self.relatedPeopleView.viewAllTapDelegate = self
        
        
        
    }
    
    func updateButtonStatus() {
        if escapeAlreadyAdded {
            self.addEditEscapeButton.setTitle("Edit", for: .normal)
        } else {
            self.addEditEscapeButton.setTitle("+ Add", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ScreenVader.sharedVader.hideTabBar(true)
        ScreenVader.sharedVader.changeStatusBarPreference(false)
        
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
        if let escapeItem = escapeItem {
            setEscapeDetails(escapeItem.name, subtitle: nil, year: escapeItem.year, image:escapeItem.posterImage, rating: escapeItem.rating)
        }
        
        if let escapeType = self.escapeType {
            if escapeType == .Books {
                self.runTimeImage.image = UIImage(named: "pages_count")
                self.similarEscapesView.updateTitle(title: "Similar Books")
            }
            
            if escapeType == .Movie {
                self.similarEscapesView.updateTitle(title: "Similar Movies")
            }
            
            if escapeType == .TvShows {
                self.similarEscapesView.updateTitle(title: "Similar Tv Shows")
            }
        }
        
        self.view.layoutIfNeeded()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let escapeId = self.escapeId, let escapeName = self.escapeName, let escapeType = self.escapeType {
            AnalyticsVader.sharedVader.itemDescriptionOpened(escapeName: escapeName, escapeId: escapeId, escapeType: escapeType.rawValue)
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let escapeId = self.escapeId, let escapeName = self.escapeName, let escapeType = self.escapeType {
            AnalyticsVader.sharedVader.itemDescriptionClosed(escapeName: escapeName, escapeId: escapeId, escapeType: escapeType.rawValue)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ScreenVader.sharedVader.changeStatusBarPreference(true)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setVisuals(){
        let settingImage = IonIcons.image(withIcon: ion_android_options, size: 30, color: UIColor.white)
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemDescViewController.optionsTapped))
        
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    func setEscapeDetails(_ name: String, subtitle: String?, year: String?, image: String?, rating: String?) {
        
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
            
            
        }
        
        if let rating = rating {
            ratingLabel.text = "\(rating)"
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fillData(_ descData : DescDataItems?){
        
        if let descData = descData {
            
            if let escapeName = descData.name {
                self.escapeName = descData.name
                
                var ratingStr:String?
                
                if let rating = descData.rating {
                    ratingStr = rating.stringValue
                }
                
                setEscapeDetails(escapeName, subtitle: descData.subtitle, year: descData.releaseYear, image: descData.image, rating: ratingStr)
            }
            
            if let image = descData.image{
                self.imageUri = image
                itemImage.downloadImageWithUrl(image, placeHolder: UIImage(named: "movie_placeholder"))
            }
            
            if let backdropImage = descData.backDropImage {
                headerImage.downloadImageWithUrl(backdropImage, placeHolder: nil)
            }
            
            if let runtime = descData.runtime{
                runTimeLabel.text = runtime
            }
            if let createdBy = descData.createdBy {
                self.createdBy = createdBy
                
                var text = "Directed by"
                if let escapeType = self.escapeType {
                    
                    if escapeType == .Books {
                        text = "Author"
                    }else if escapeType == .TvShows {
                        text = "Creator"
                    }
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
                if desc.characters.count > 60 {
                    self.readMoreButton.visibleWithAnimation()
                }
            }
            
            escapeAlreadyAdded  = descData.isActed
            
            setVisuals()
            addEditEscapeButton.isHidden = false
            updateButtonStatus()
        }
        
    }
    func getString(_ title : String , str : String) -> NSAttributedString{
        
        let titleString = SFUIAttributedText.mediumAttributedTextForString("\(title) : ", size: 16, color: UIColor.textBlackColor())
        
        let descString = SFUIAttributedText.regularAttributedTextForString(str, size: 14, color: UIColor.textGrayColor())
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(titleString)
        attributedString.append(descString)
        return attributedString
    }
    
    @IBAction func dismissViewController(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func readMoreButtonTap(_ sender: UIButton) {
        self.descriptionLabel.numberOfLines = 0
        self.readMoreButton.setTitle("", for: .normal)
        self.readMoreButton.hideWithAnimationAndRemoveView(false)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func addEscapeTapped(_ sender: AnyObject) {
        
        if let escapeId = self.escapeId, let escapeType = self.escapeType, let escapeName = self.escapeName {
            var paramsToPass: [String:Any] = ["escape_id" : escapeId, "escape_type":escapeType, "escape_name": escapeName, "delegate" : self]
            
            if let createdBy = self.createdBy {
                paramsToPass["createdBy"] = createdBy
            }
            
            if let imageUri = self.imageUri {
                paramsToPass["escape_image"] = imageUri
            }
            
            if escapeAlreadyAdded {
                ScreenVader.sharedVader.performScreenManagerAction(.OpenEditEscapePopUp, queryParams: paramsToPass)
            } else {
                ScreenVader.sharedVader.performScreenManagerAction(.OpenAddToEscapePopUp, queryParams: paramsToPass)
            }
        }
    }
    
    
    func postRecommend(_ friendIds : [String]){
        if let escapeId = escapeId {
            MyAccountDataProvider.sharedDataProvider.postRecommend([escapeId], friendId: friendIds, message: "New Recommendation for you")
        }
    }
    
    @IBAction func recommendToFriendsTapped(_ sender: AnyObject) {
        
        if let _ = self.escapeId {
            
            if let escapeId = self.escapeId, let escapeName = self.escapeName, let escapeType = self.escapeType {
                
            }
            
            let storyBoard = UIStoryboard(name: "MyAccount", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "friendsVC") as! CustomNavigationViewController
            let rootVC = vc.viewControllers[0] as! FriendsViewController
            
            rootVC.freindsDelegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
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
        tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor.clear
        self.popover = Popover(options: self.popoverOptions, showHandler: nil, dismissHandler: nil)
        self.popover.show(tableView, fromView: viewX)
        
    }
}
extension ItemDescViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popover.dismiss()
        
        if optionsArray[indexPath.row] == .Recommend{
        
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text =  optionsArray[indexPath.row].rawValue
        
        if(indexPath.row != self.optionsArray.count-1){
            let line = UIView(frame: CGRect(x: 0, y: 44, width: tableView.frame.width, height: 1))
            line.backgroundColor = UIColor.groupTableViewBackground
            cell.addSubview(line)
            
        }
        return cell
    }
    
}

extension ItemDescViewController: EditEscapeProtocol {
    func didDeleteEscape() {
        
        self.escapeAlreadyAdded = false
        updateButtonStatus()
    }
}

extension ItemDescViewController: AddToEscapeDoneProtocol {
    func doneButtonTapped() {
        self.escapeAlreadyAdded = true
        updateButtonStatus()
    }
    
}

extension ItemDescViewController : ItemDescProtocol{
    
    func receivedItemDesc(_ data: DescDataItems?, id: String) {
        
        if let data = data  {
            if let escapeType = data.escapeType {
                self.escapeType = EscapeType(rawValue: escapeType)
            }
            
        }
        fillData(data)
        
        self.similarEscapesView.getSimilarEscapesData(escapeId: id, escapeType: self.escapeType)
        self.relatedPeopleView.getRelatedPeopleData(escapeId: id)
    }
    
    func errorItemDescData() {
        
    }
}

extension ItemDescViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            
//            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
//            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            let blurOffset = offset/offset_HeaderStop
            if offset > 0 && blurOffset < 1.01 {
                //visualEffectsLayer.alpha = max(0.7, blurOffset)
            }
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / itemImage.bounds.height / 1.8 // Slow down the animation
            let avatarSizeVariation = ((itemImage.bounds.height * (1.0 + avatarScaleFactor)) - itemImage.bounds.height) / 2.0
//            imageTransform = CATransform3DTranslate(imageTransform, 0, avatarSizeVariation, 0)
//            imageTransform = CATransform3DScale(imageTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
//            if offset <= offset_HeaderStop {
//                
//                if itemImage.layer.zPosition < headerView.layer.zPosition{
//                    headerView.layer.zPosition = 0
//                    headerLabel.layer.zPosition = 0
//                    ovalImage.layer.zPosition = 0
//                }
//                
//            }else {
//                if itemImage.layer.zPosition >= headerView.layer.zPosition{
//                    headerView.layer.zPosition = 1
//                    ovalImage.layer.zPosition = 1
//                    headerLabel.layer.zPosition = 2
//                }
//            }
        }
        
        
        // Apply Transformations
        
        headerView.layer.transform = headerTransform
        itemImage.layer.transform = imageTransform
        
    }
}

extension ItemDescViewController: FriendsProtocol {
    func taggedFriendIds(_ ids : [String]) {
        postRecommend(ids)
    }
}

extension ItemDescViewController: RelatedPeopleViewAllTapProtocol {
    func viewAllTappedInRelatedPeople() {
        if let escapeId = self.escapeId, let escapeType = self.escapeType {
            
            ScreenVader.sharedVader.performScreenManagerAction(.OpenRelatedPeopleView, queryParams: ["escapeId": escapeId, "escapeType":escapeType])
        }
    }
}

extension ItemDescViewController: SimilarEscapesViewAllTapProtocol {
    func viewAllTappedIn() {
        if let escapeId = self.escapeId, let escapeType = self.escapeType {
            
            ScreenVader.sharedVader.performScreenManagerAction(.OpenSimilarEscapesView, queryParams: ["escapeId": escapeId, "escapeType":escapeType])
        }
    }
}
