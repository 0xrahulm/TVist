//
//  RealmDataVader.swift
//  Escape
//
//  Created by Rahul Meena on 23/11/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import UIKit
import RealmSwift

class RealmDataVader: NSObject {
    
    static let sharedVader = RealmDataVader()
    
    var realm: Realm!
    
    override init() {
        super.init()
        
        var config = handleMigrationsIfAny()
        
        config.fileURL = fileUrlForRealmWithCofiguration(config)
        
        realm = try! Realm(configuration: config)
        
    }
    
    func fileUrlForRealmWithCofiguration(_ config:Realm.Configuration) -> URL? {
        return config.fileURL?.deletingLastPathComponent().appendingPathComponent("escape.rl")
    }
    
    
    func getUserById(_ userId: String) -> UserData? {
        
        if let realm = realm {
            let predicate = NSPredicate(format: "id == %@", userId)
            return realm.objects(UserData.self).filter(predicate).first
        }
        
        return nil
    }
    
    func handleMigrationsIfAny() -> Realm.Configuration {
        
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                
                switch(oldSchemaVersion) {
                case _ where oldSchemaVersion < 1:
                    // Nothing to do in this version
                    break
                default:
                    break
                }
        })
        
        return config
    }
    
    
    func getProfileListData(_ listType: ProfileListType, userId: String) -> Results<ProfileList> {
        let predicate = NSPredicate(format: "userId == %@ AND type == %@", userId, listType.rawValue)
        return realm.objects(ProfileList.self).filter(predicate)
    }
    
    
    func writeToRealm(_ object: Object) {
        DispatchQueue.global(qos: .userInitiated).async {[unowned self]
            () -> Void in
            try! self.realm.write({
                self.realm.add(object)
            })
        }
    }
    
    
    
    func writeOrUpdateProfileList(_ userId:String, type:String, listData:[[String:AnyObject]]) {
        let id = userId+type // Constructed id
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self]
            () -> Void in
            var config = self.handleMigrationsIfAny()
            config.fileURL = self.fileUrlForRealmWithCofiguration(config)
            let _realm = try! Realm(configuration: config)
            if let profileList = _realm.object(ofType: ProfileList.self, forPrimaryKey: id) {
                
                try! _realm.write({
                    profileList.data.removeAll()
                    profileList.parseDataList(listData, _realm: _realm)
                })
            } else {
                let profileList = ProfileList()
                profileList.id = id
                profileList.userId = userId
                profileList.type   = type
                
                
                try! _realm.write({
                    
                    profileList.parseDataList(listData, _realm: _realm)
                    _realm.add(profileList)
                })
            }
            
        }
    }
}
