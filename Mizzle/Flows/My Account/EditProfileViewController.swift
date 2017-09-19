//
//  MyAccountSettingViewController.swift
//  Escape
//
//  Created by Ankit on 15/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import AWSS3
import AWSCognito

protocol ProfileImageChangeProtocol: class {
    func didChangeProfilePic(image: UIImage)
}

class EditProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var transferManager:AWSS3TransferManager!
    
    var settingItems: [SettingItem] {
        get {
            
            var items: [SettingItem] = []
            items.append(SettingItem(title: "Change Avatar", type: SettingItemType.profilePicture, action: nil))
            
            if let user = MyAccountDataProvider.sharedDataProvider.currentUser {
                if let email = user.email, email != "" {
                    items.append(SettingItem(title: "Email", type: SettingItemType.selectedOption, action: nil, subTitle: email, isEnabled: false))
                } else {
                    items.append(SettingItem(title: "Email", type: SettingItemType.selectedOption, action: nil, subTitle: "Tap to provide", isEnabled: false))
                }
                
                if user.firstName != "" {
                    items.append(SettingItem(title: "First Name", type: SettingItemType.selectedOption, action: nil, subTitle: user.firstName))
                } else {
                    items.append(SettingItem(title: "First Name", type: SettingItemType.selectedOption, action: nil, subTitle: "Tap to provide"))
                }
                
                if user.lastName != "" {
                    items.append(SettingItem(title: "Last Name", type: SettingItemType.selectedOption, action: nil, subTitle: user.lastName))
                } else {
                    items.append(SettingItem(title: "Last Name", type: SettingItemType.selectedOption, action: nil, subTitle: "Tap to provide"))
                }
            }
            
            return items
        }
    }
    
    
    
    weak var imageChangeDelegate:ProfileImageChangeProtocol?
    
    override func setObjectsWithQueryParameters(_ queryParams: [String : Any]) {
        if let delegate = queryParams["delegate"] as? ProfileImageChangeProtocol {
            self.imageChangeDelegate = delegate
        }
    }
    
    var presentToast : UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                identityPoolId:"us-west-2:9bcfada0-e58b-4174-8434-4634f57232eb")
        
        let configuration = AWSServiceConfiguration(region:.USWest1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        presentToast = UIApplication.shared.keyWindow
        // Do any additional setup after loading the view.
        transferManager = AWSS3TransferManager.default()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func identifierForCellType(type: SettingItemType) -> String {
        
        switch type {
        case .authButton:
            return SettingCellIdentifiers.authCell.rawValue
        case .selectedOption:
            return SettingCellIdentifiers.selectedOptionCell.rawValue
        case .onOffSetting:
            return SettingCellIdentifiers.onOffCell.rawValue
        case .profilePicture:
            return SettingCellIdentifiers.profilePictureCell.rawValue
        default:
            return SettingCellIdentifiers.regularCell.rawValue
        }
        
    }
    
}
extension EditProfileViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settingItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierForCellType(type: item.type), for: indexPath) as! SettingsBaseTableViewCell
        cell.settingItem = item
        
        if indexPath.row == settingItems.count-1 {
            cell.makeBottomLineFull()
        }
        
        cell.upperLine.isHidden = indexPath.row != 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = settingItems[indexPath.row]
        
        if item.type == SettingItemType.profilePicture {
            return 74
        }
        
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settingItems[indexPath.row]
        
        if item.type == SettingItemType.profilePicture {
            
            let alert = UIAlertController(title: "Pick photo from?", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }))
            
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                // Cancel
            }))
            
            alert.popoverPresentationController?.sourceView = self.view
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //        if dataArray[indexPath.row] == .Logout{
        //            MyAccountDataProvider.sharedDataProvider.logoutUser()
        //        }else if dataArray[indexPath.row] == .EditProfile{
        //        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var finalSelectedImage:UIImage!
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            finalSelectedImage = selectedImage
        }
        
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            finalSelectedImage = selectedImage
        }
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        if let currentUserId = ECUserDefaults.getCurrentUserId() {
            let key = currentUserId+"-"+String(arc4random_uniform(201) + 1)+".jpg"
            let path = "\(documentsPath)/\(key)"
            
            if let imageData = UIImageJPEGRepresentation(finalSelectedImage, 0.6) {
                
                if let image = UIImage(data: imageData) {
                    
                    if let imageChangeDelegate = imageChangeDelegate {
                        imageChangeDelegate.didChangeProfilePic(image: image)
                        if let toast = self.presentToast {
                            toast.makeToast(message: "Profile picture changed successfully.", duration: 3.0, position: HRToastPositionDefault as AnyObject)
                        }
                        
                    }
                }
                
                let uploadingFileURL = URL(fileURLWithPath: path)
                try! imageData.write(to: uploadingFileURL, options: .atomic)
                
                
                if let uploadRequest = AWSS3TransferManagerUploadRequest() {
                    
                    
                    uploadRequest.bucket = "escape-app-user-profile-images"
                    uploadRequest.key = key
                    uploadRequest.body = uploadingFileURL
                    uploadRequest.contentType = "image/jpeg"
                    
                    transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                        
                        if let error = task.error {
                            Logger.debug("error \(error.localizedDescription)")
                        }
                        
                        if let uploadOutput = task.result {
                            Logger.debug("Result: \(uploadOutput)")
                            MyAccountDataProvider.sharedDataProvider.updateProfilePicture(pictureName: key)
                            
                        }
                        
                        if let key = uploadRequest.key {
                            Logger.debug("Upload complete for: \(key)")
                        }
                        return nil
                    })
                }
                
                
            }
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}
