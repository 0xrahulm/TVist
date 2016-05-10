//
//  User.swift
//  Escape
//
//  Created by Ankit on 08/05/16.
//  Copyright © 2016 EscapeApp. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    class func createOrUpdateData(id: String?, firstName: String?, lastName: String?, email: String?, gender: NSNumber?, profilePicture: String?, followers: NSNumber?, following: NSNumber?, escapes_count : NSNumber?) -> User {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            print(result)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        var userExist = false
        var user : User!
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            
            for item in result{
                if let userid = item.valueForKey("user_id") as? String{
                    if id == userid {
                        userExist = true
                        user = item as! User
                        break
                    }
                    
                }
            }
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        if !userExist{
            user = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedContext) as! User
            
        }
        user.setValue(firstName, forKey: "firstName")
        user.setValue(lastName, forKey: "lastName")
        user.setValue(email, forKey: "email")
        user.setValue(escapes_count, forKey: "escapes")
        user.setValue(followers, forKey: "followers")
        user.setValue(following, forKey: "following")
        user.setValue(gender, forKey: "gender")
        user.setValue(id, forKey: "user_id")
        user.setValue(profilePicture, forKey: "profilePicture")
        
        
        do {
            try managedContext.save()
            print("data saved to core data")
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return user
    }
    
}
