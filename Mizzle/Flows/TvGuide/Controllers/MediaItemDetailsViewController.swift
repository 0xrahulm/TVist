//
//  MediaItemDetailsViewController.swift
//  Mizzle
//
//  Created by Rahul Meena on 15/06/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit
import SafariServices

class MediaItemDetailsViewController: BaseViewController, ViewingOptionsProtocol {
    
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var ovalImage: UIImageView!
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    
    
    @IBOutlet weak var headerLabel: UILabel!
    
    
    
    @IBOutlet weak var similarEscapesView: SimilarEscapesView!
    
    @IBOutlet weak var itemTitle:       UILabel!
    @IBOutlet weak var yearLabel:       UILabel!
    @IBOutlet weak var ratingLabel:     UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var infoView: MediaInfoView!
    
    
    
    
    
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var seenButton: UIButton!
    
    @IBOutlet weak var editButtonBackground: UIView!
    @IBOutlet weak var seenButtonBackground: UIView!
    
    @IBOutlet weak var opaqueBar: UIView!
    
    
    // Tv Airtimes section
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var moreAirtimesButton: UIButton!
    @IBOutlet weak var channelImageLogo: UIImageView!
    
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    
    var escapeId:String?
    var escapeType:EscapeType?
    var imageUri: String?
    var escapeName: String?
    var createdBy: String?
    var imdbId: String?
    
    var loadedOnce: Bool = false
    
    var isAlertSet: Bool    = false
    var isAlreadySeen: Bool = false
    
    
    let offset_HeaderStop:CGFloat = 140.0 // At this offset the Header stops its transformations
    let offset_B_LabelHeader:CGFloat = 145.0 // At this offset the Black label reaches the Header
    let distance_W_LabelHeader:CGFloat = 25.0
    
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
    
    var callOnce:Bool = false
    var segmentedTabs: [UIView] = []
    
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
    
    override func getName() -> String {
        return ScreenNames.MediaDescription.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        MyAccountDataProvider.sharedDataProvider.itemDescDelegate = self
        
        if let escapeItem = self.escapeItem {
            self.escapeType = escapeItem.escapeTypeVal()
            self.escapeId   = escapeItem.id
            self.escapeName = escapeItem.name
            self.imageUri = escapeItem.posterImage
            self.escapeAlreadyAdded = escapeItem.hasActed
            self.isAlertSet = escapeItem.isAlertSet
            
        }
        
        if let escapeId = self.escapeId {
            MyAccountDataProvider.sharedDataProvider.getItemDesc(self.escapeType, id: escapeId)
        }
        
        if watchlistButton != nil {
            
            watchlistButton.setImage(UIImage(named: "WatchlistAddIcon"), for: .normal)
            watchlistButton.setImage(IonIcons.image(withIcon: ion_android_done_all, size: 25, color: UIColor.white), for: .selected)
            
            watchlistButton.setTitle("Add", for: .normal)
            watchlistButton.setTitle("Added", for: .selected)
            
        }
        
        updateButtonStatus()
        
        self.similarEscapesView.viewAllTapDelegate = self
        //        self.relatedPeopleView.viewAllTapDelegate = self
//        self.viewingOptions.delegate = self
        
        
        
        self.view.layoutIfNeeded()
        setupButtons()
        setupTabs()
    }
    
    func updateButtonStatus() {
        self.watchlistButton.isHidden = escapeAlreadyAdded
        
        markSeenButton(isHidden: !escapeAlreadyAdded)
        markEditButton(isHidden: !escapeAlreadyAdded || isAlreadySeen)
    }
    
    func markSeenButton(isHidden: Bool) {
        self.seenButton.isHidden = isHidden
        self.seenButtonBackground.isHidden = isHidden
        self.seenButton.isSelected = self.isAlreadySeen
        
        if self.seenButton.isSelected {
            self.seenButton.backgroundColor = UIColor.styleGuideActionRed()
        } else {
            self.seenButton.backgroundColor = UIColor.white
        }
    }
    
    func markEditButton(isHidden: Bool) {
        self.editButton.isHidden = isHidden
        self.editButtonBackground.isHidden = isHidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ScreenVader.sharedVader.hideTabBar(true)
        ScreenVader.sharedVader.changeStatusBarPreference(false)
        
        if !loadedOnce {
            if let escapeItem = escapeItem {
                setEscapeDetails(escapeItem.name, subtitle: nil, year: escapeItem.year, image:escapeItem.posterImage, rating: escapeItem.rating)
                airtimeViewUpdate(nextAirtime: escapeItem.nextAirtime)
                
                updateWatchlistButton(newState: escapeItem.hasActed)
            }
            
        }
        
        loadedOnce = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !callOnce {
            if let escapeId = self.escapeId, let escapeName = self.escapeName, let escapeType = self.escapeType {
                AnalyticsVader.sharedVader.itemDescriptionOpened(escapeName: escapeName, escapeId: escapeId, escapeType: escapeType.rawValue)
            }
            callOnce = true
        }
        fixNavigationBarCorruption()
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
    
    func airtimeViewUpdate(nextAirtime: Airtime?) {
        
        if let nextAirtime = nextAirtime {
            self.dayTimeLabel.text = nextAirtime.dayText()+", "+nextAirtime.airTime
            
            if let episodeString = nextAirtime.episodeString {
                self.seasonEpisodeLabel.text = episodeString
            } else {
                self.seasonEpisodeLabel.text = nextAirtime.channelName
            }
            
            self.channelImageLogo.downloadImageWithUrl(nextAirtime.channelIcon, placeHolder: IconsUtility.airtimeIcon())
        } else {
            
            self.channelImageLogo.image = IconsUtility.airtimeIcon()
            self.dayTimeLabel.text = "Not airing in the next 7 days"
            self.seasonEpisodeLabel.text = nil
        }
    }
    
    @IBAction func didTapOnAllAirtimes(sender: UIButton) {
        AnalyticsVader.sharedVader.basicEvents(eventName: .AllAirtimesClick)
        if let escapeId = self.escapeId, let escapeName = self.escapeName {
            let params:[String:Any] = ["escapeId": escapeId, "title": escapeName]
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openAllAirtimesView, queryParams: params)
        }
        
//        if let storyboard = self.storyboard {
//            if let viewController = storyboard.instantiateViewController(withIdentifier: "AllAirtimesViewController") as? AllAirtimesViewController {
//
//                viewController.escapeId = self.escapeId
//                viewController.title = self.escapeName
//
//                self.navigationController?.pushViewController(viewController, animated: true)
//
//            }
//        }
    }
    
    func setupButtons() {
        self.seenButton.setImage(IonIcons.image(withIcon: ion_android_done_all, size: 18, color: UIColor.white), for: .selected)
    }
    
    func setupTabs() {
        
        //        let segmentControl = WBSegmentControl()
        //
        //        var similarSectionTitle:String = "SIMILAR SHOWS"
        //        if let escapeType = self.escapeType {
        //            if escapeType == .Books {
        //                similarSectionTitle = "SIMILAR BOOKS"
        //            } else if escapeType == .Movie {
        //                similarSectionTitle = "SIMILAR MOVIES"
        //            } else if escapeType == .TvShows {
        //                similarSectionTitle = "SIMILAR SHOWS"
        //            }
        //        }
        //
        //
        //        segmentControl.segmentTextFontSize = 16
        //        segmentControl.segmentMinWidth = 90
        //        segmentControl.segments = [
        //            TextSegment(text: "WHERE TO WATCH"),
        //            TextSegment(text: "DETAILS"),
        //            TextSegment(text: "RELATED VIDEOS"),
        //            TextSegment(text: similarSectionTitle)
        //        ]
        //
        //        segmentedTabs = [viewingOptions,infoView,UIView(),similarEscapesView]
        //        segmentControl.style = .strip
        //        segmentControl.delegate = self
        //        segmentControl.strip_color = UIColor.defaultTintColor()
        //
        //        segmentControl.selectedIndex = 0
    }
    
    func setVisuals(){
        let settingImage = IonIcons.image(withIcon: ion_android_options, size: 30, color: UIColor.white)
        let settingButton : UIBarButtonItem = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(MediaItemDetailsViewController.optionsTapped))
        
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    func setEscapeDetails(_ name: String, subtitle: String?, year: String?, image: String?, rating: String?) {
        
        if let subtitle = subtitle {
            itemTitle.text = name+" - "+subtitle
        } else {
            itemTitle.text = name
        }
        genreLabel.text = "..."
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
                    ratingStr = String(format: "%.1f", rating.doubleValue)
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
            
            self.imdbId = descData.imdbId
            
            if let runtime = descData.runtime{
                self.infoView.runTimeLabel.text = runtime
            }
            if let createdBy = descData.createdBy {
                self.createdBy = createdBy
                
                var text = "Director"
                if let escapeType = self.escapeType {
                    
                    if escapeType == .Books {
                        text = "Author"
                    }else if escapeType == .TvShows {
                        text = "Creator"
                    }
                }
                
                self.infoView.creatorTypeLabel.text = text
                self.infoView.creatorLabel.text = createdBy
            }
            if let cast = descData.cast{
                self.infoView.castDetailLabel.text = cast
            } else {
                self.infoView.castDetailLabel.text = nil
                self.infoView.castLabel.text = nil
            }
            if descData.generes.count > 0{
                var gerenes = ""
                var i = 0
                for gen in descData.generes{
                    if i == 0{
                        gerenes = gerenes + gen
                    }else{
                        gerenes = gerenes + " | \(gen)"
                    }
                    i = i + 1
                }
                self.genreLabel.text = gerenes
                //                generesLabel.attributedText = getString("Generes", str: gerenes)
                
            }
            if let desc = descData.desc{
                self.infoView.descriptionLabel.text = desc
                if desc.characters.count > 60 {
                    
                }
            }
            
            self.escapeAlreadyAdded = descData.inWatchlist
            self.isAlreadySeen = descData.isAlreadySeen
            self.isAlertSet = descData.isAlertSet
            
            setVisuals()
            airtimeViewUpdate(nextAirtime: descData.nextAirtime)
            
            updateButtonStatus()
//            self.viewingOptions.updateStreamingData(streamingOptions: descData.streamingOptions)
            
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
        self.infoView.descriptionLabel.numberOfLines = 0
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
            
            ScreenVader.sharedVader.performScreenManagerAction(.OpenEditEscapePopUp, queryParams: paramsToPass)
            if escapeAlreadyAdded {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.AddButtonTap, properties: ["escapeName":escapeName, "escapeId": escapeId, "escapeType":escapeType.rawValue])
            } else {
                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.EditButtonTap, properties: ["escapeName":escapeName, "escapeId": escapeId, "escapeType":escapeType.rawValue])
            }
        }
    }
    
    
    func postRecommend(_ friendIds : [String]){
        if let escapeId = escapeId {
            MyAccountDataProvider.sharedDataProvider.postRecommend([escapeId], friendId: friendIds, message: "New Recommendation for you")
        }
    }
    
    @IBAction func seenButtonTapped(_ sender: UIButton) {
        self.isAlreadySeen = !self.isAlreadySeen
        
        if let escapeId = self.escapeId, let escapeName = self.escapeName, let escapeType = self.escapeType {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SeenButtonTap, properties: ["escapeName":escapeName, "escapeId": escapeId, "escapeType":escapeType.rawValue])
        }
        if self.isAlreadySeen {
            if let escapeId = self.escapeId {
                WatchlistDataProvider.shared.markEscapeSeen(escapeId: escapeId)
            }
            self.seenButton.isSelected = true
            updateButtonStatus()
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
        if let escapeItem = self.escapeItem {
            
            if let escapeId = self.escapeId {
                
                if let itemName = escapeName {
                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.EditButtonTap, properties: ["itemName": itemName, "itemId": escapeId])
                }
                
            }
            
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openAddToWatchlistView, queryParams: ["mediaItem": escapeItem, "delegate": self])
        }
    }
    
    @IBAction func watchlistButtonTapped(sender: UIButton) {
        toggleWatchlistButton()
    }
    
    //    func toggleAlreadySeenButton() {
    //
    //        seenButton.popButtonAnimate()
    //        let newState = !seenButton.isSelected
    //
    //        if !newState {
    //
    //            if let itemName = escapeName {
    //
    //                let alert = UIAlertController(title: "Are you sure?", message: "\(itemName) is currently in your watchlist, would you like to remove it?", preferredStyle: .alert)
    //
    //
    //                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
    //
    //                    self.isAlreadySeen = newState
    //                    if let escapeId = self.escapeId {
    //                        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UndoSeen, properties: ["itemName": itemName, "itemId": escapeId])
    //                        MyAccountDataProvider.sharedDataProvider.removeEscape(escapeId: escapeId)
    //                    }
    //                    self.updateAlreadySeenButton(newState: newState)
    //
    //                })
    //
    //                alert.addAction(removeAction)
    //
    //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //
    //                alert.addAction(cancelAction)
    //
    //                ScreenVader.sharedVader.showAlert(alert: alert)
    //            }
    //        } else {
    //            self.isAlreadySeen = newState
    //            if let escapeId = self.escapeId {
    //
    //                if let itemName = escapeName {
    //                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.AddedToSeen, properties: ["itemName": itemName, "itemId": escapeId])
    //                }
    //                UserDataProvider.sharedDataProvider.addToEscape(escapeId, action: EscapeAddActions.Watched, status: "", friendsId: [], shareFB: 1)
    //            }
    //
    //            updateAlreadySeenButton(newState:newState)
    //        }
    //    }
    
    func toggleWatchlistButton() {
        watchlistButton.popButtonAnimate()
        let newState = !watchlistButton.isSelected
        
        if !newState {
            
            if let itemName = escapeName {
                
                let alert = UIAlertController(title: "Are you sure?", message: "\(itemName) is currently in your watchlist, would you like to remove it?", preferredStyle: .alert)
                
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    
                    self.escapeAlreadyAdded = newState
                    if let escapeId = self.escapeId {
                        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.UndoWatchlist, properties: ["itemName": itemName, "itemId": escapeId])
                        MyAccountDataProvider.sharedDataProvider.removeEscape(escapeId: escapeId)
                    }
                    self.updateWatchlistButton(newState: newState)
                    
                })
                
                alert.addAction(removeAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                
                ScreenVader.sharedVader.showAlert(alert: alert)
            }
        } else {
            
            if let escapeId = self.escapeId {
                
                if let itemName = escapeName {
                    AnalyticsVader.sharedVader.basicEvents(eventName: EventName.AddButtonTap, properties: ["itemName": itemName, "itemId": escapeId])
                }
                
            }
            
            if let escapeItem = self.escapeItem {
                ScreenVader.sharedVader.performUniversalScreenManagerAction(.openAddToWatchlistView, queryParams: ["mediaItem": escapeItem, "delegate": self])
            }
            
        }
    }
    
    
    @IBAction func trackButtonTapped(sender: UIButton) {
        toggleButtonState()
    }
    
    func toggleButtonState() {
        trackButton.popButtonAnimate()
        let newState = !trackButton.isSelected
        if !newState {
            if let itemName = escapeName {
                
                let alert = UIAlertController(title: "Are you sure?", message: "Tracking for \(itemName) is already setup, would you like to remove it?", preferredStyle: .alert)
                
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    
                    self.isAlertSet = newState
                    if let escapeId = self.escapeId {
                        
                        if let escapeName = self.escapeName, let escapeType = self.escapeType {
                            AnalyticsVader.sharedVader.undoTrack(escapeName: escapeName, escapeId: escapeId, escapeType: escapeType.rawValue, position: "Item Details Page")
                        }
                        TrackingDataProvider.shared.removeTrackingFor(escapeId: escapeId)
                    }
                    self.updateTrackButton(newState: newState)
                    
                })
                
                alert.addAction(removeAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                
                ScreenVader.sharedVader.showAlert(alert: alert)
            }
        } else {
            self.isAlertSet = newState
            
            if let escapeId = self.escapeId {
                
                if let escapeName = self.escapeName, let escapeType = self.escapeType {
                    AnalyticsVader.sharedVader.trackButtonClicked(escapeName: escapeName, escapeId: escapeId, escapeType: escapeType.rawValue, position: "Item Details Page")
                }
                TrackingDataProvider.shared.addTrackingFor(escapeId: escapeId)
            }
            updateTrackButton(newState: newState)
            
        }
    }
    
    
    func updateTrackButton(newState: Bool) {
//        trackButton.isSelected = newState
    }
    
    
    
    func updateWatchlistButton(newState: Bool) {
        
        watchlistButton.isSelected = newState
        //        if newState {
        //            watchlistButton.backgroundColor = UIColor.buttonGrayColor()
        //        } else {
        //            watchlistButton.backgroundColor = UIColor.buttonGrayColor()
        //        }
    }
    
    
    
    //    func updateAlreadySeenButton(newState: Bool) {
    //
    //        seenButton.isSelected = newState
    //        if newState {
    //            seenButton.backgroundColor = UIColor.defaultTintColor()
    //        } else {
    //            seenButton.backgroundColor = UIColor.white
    //        }
    //    }
    
    func didTapOnViewingOption(viewingOption: StreamingOption) {
        
        if let viewingOptionName = viewingOption.name {
            AnalyticsVader.sharedVader.basicEvents(eventName: EventName.ViewingOptionsClick, properties: ["Option":viewingOptionName])
        }
        if let viewOptionLink = viewingOption.link {
            
            if let url = URL(string: viewOptionLink) {
                if let scheme = url.scheme {
                    if scheme != "http" && scheme != "https" {
                        UIApplication.shared.openURL(url)
                        return
                    }
                }
                let safari = SFSafariViewController(url: url)
                self.present(safari, animated: true, completion: nil)
            }
            
        }
    }
    
    
    @IBAction func seeImdbDetailsTapped(_ sender: AnyObject) {
        AnalyticsVader.sharedVader.basicEvents(eventName: EventName.SeeImdbDetailsClick)
        
        if let imdbId = self.imdbId {
            if let url = URL(string: "http://www.imdb.com/title/\(imdbId)") {
                
                let safari = SFSafariViewController(url: url)
                self.present(safari, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func recommendToFriendsTapped(_ sender: AnyObject) {
        
        if let _ = self.escapeId {
            
            if let escapeId = self.escapeId, let escapeName = self.escapeName, let escapeType = self.escapeType {
//                AnalyticsVader.sharedVader.shareWithFriendsTapped(escapeName: escapeName, escapeId: escapeId, escapeType: escapeType.rawValue)
            }
            
            let storyBoard = UIStoryboard(name: "MyAccount", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "friendsVC") as! CustomNavigationViewController
            let rootVC = vc.viewControllers[0] as! FriendsViewController
            
            rootVC.freindsDelegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func optionsTapped(){
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
    
    func toggleViewAtIndex(selectedIndex: Int) {
        for (index, view) in segmentedTabs.enumerated() {
            if selectedIndex == index {
                view.visibleWithAnimationDuration(0.2)
            } else {
                view.hideWithAnimationAndRemoveView(false, duration: 0.2)
            }
        }
    }
}

//extension MediaItemDetailsViewController: WBSegmentControlDelegate {
//    func segmentControl(_ segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {
//        if newIndex == 3 {
//            if let id = self.escapeId {
//                self.similarEscapesView.getSimilarEscapesData(escapeId: id, escapeType: self.escapeType)
//            }
//        }
//
//        if let escapeType = self.escapeType, let escapeName = self.escapeName, oldIndex != -1 {
//
//            if let selectedSegment = segmentControl.segments[newIndex] as? TextSegment {
//                AnalyticsVader.sharedVader.basicEvents(eventName: EventName.DetailsPageSegmentClick, properties: ["Tab Name": selectedSegment.text, "escape_name":escapeName, "escape_type":escapeType.rawValue])
//            }
//        }
//        toggleViewAtIndex(selectedIndex: newIndex)
//    }
//}

extension MediaItemDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
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

extension MediaItemDetailsViewController: EditEscapeProtocol {
    func didDeleteEscape() {
        
        self.escapeAlreadyAdded = false
        updateButtonStatus()
    }
}

extension MediaItemDetailsViewController: AddToEscapeDoneProtocol {
    func doneButtonTapped() {
        self.escapeAlreadyAdded = true
        updateButtonStatus()
    }
    
}

extension MediaItemDetailsViewController : ItemDescProtocol{
    
    func receivedItemDesc(_ data: DescDataItems?, id: String) {
        
        if let data = data  {
            if let escapeType = data.escapeType {
                self.escapeType = EscapeType(rawValue: escapeType)
            }
            
        }
        fillData(data)
        
        self.similarEscapesView.getSimilarEscapesData(escapeId: id, escapeType: self.escapeType)
        //        self.relatedPeopleView.getRelatedPeopleData(escapeId: id)
    }
    
    func errorItemDescData() {
        
    }
}

extension MediaItemDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            
        }
        else {
            
            let blurOffset = offset/offset_HeaderStop
            
            if offset > 0 && blurOffset < 1.01 {
                opaqueBar.alpha = max(0.01, blurOffset)
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        var imageTransform  = CATransform3DIdentity
        // Pull Down
        if offset < 0 {
//            
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
            
            
            //  ------------ Blur
            let blurOffset = offset/offset_HeaderStop
            
            if offset > 0 && blurOffset < 1.01 {
                opaqueBar.alpha = max(0.01, blurOffset)
                
            }

        }
        
        
        // Apply Transformations
        
        headerView.layer.transform = headerTransform
        itemImage.layer.transform = imageTransform
        
    }
}

extension MediaItemDetailsViewController: FriendsProtocol {
    func taggedFriendIds(_ ids : [String]) {
        postRecommend(ids)
    }
}

extension MediaItemDetailsViewController: RelatedPeopleViewAllTapProtocol {
    func viewAllTappedInRelatedPeople() {
        if let escapeId = self.escapeId, let escapeType = self.escapeType {
            
            ScreenVader.sharedVader.performScreenManagerAction(.OpenRelatedPeopleView, queryParams: ["escapeId": escapeId, "escapeType":escapeType])
        }
    }
}

extension MediaItemDetailsViewController: SimilarEscapesViewAllTapProtocol {
    func viewAllTappedIn() {
        if let escapeId = self.escapeId, let escapeType = self.escapeType {
            AnalyticsVader.sharedVader.basicEvents(eventName: .SimilarShowsViewAllClick)
            ScreenVader.sharedVader.performUniversalScreenManagerAction(.openSimilarEscapesView, queryParams: ["escapeId": escapeId, "escapeType":escapeType])
        }
    }
}

extension MediaItemDetailsViewController: AddToWatchlistPopupProtocol {
    func addToWatchlistDone(isAlertSet: Bool) {
        if let item = self.escapeItem {
            item.isAlertSet = isAlertSet
            item.hasActed = true
        }
        self.escapeAlreadyAdded = true
        self.isAlertSet = isAlertSet
        
        updateButtonStatus()
    }
}
