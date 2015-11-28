//
//  User.swift
//  CoreDataSample
//
//  Created by Ricardo Michel Reyes Martínez on 11/28/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class User: NSManagedObject
{
    class func getUser(userID: Int, completionHandler: (user: User) -> ())
    {
        let uri = "http://jsonplaceholder.typicode.com/users/\(userID)"
        
        ConnectionManager.connect(uri, method: "GET", body: nil) { (response) -> () in
            
            if let rawUser = response as? [String: AnyObject]
            {
                User.parseUser(rawUser, completionHandler: { (user) -> () in
                    completionHandler(user: user)
                })
            }
        }
    }
    
    class func getUsers(completionHandler: (user: User) -> ())
    {
        let uri = "http://jsonplaceholder.typicode.com/users"
        
        ConnectionManager.connect(uri, method: "GET", body: nil) { (response) -> () in
            
            if let rawUsers = response as? [[String: AnyObject]]
            {
                for rawUser in rawUsers
                {
                    User.parseUser(rawUser, completionHandler: { (user) -> () in
                        completionHandler(user: user)
                    })
                }
            }
        }
    }
    
    class func parseUser(rawUser: [String: AnyObject], completionHandler: (user: User) -> ())
    {
        let userID = rawUser["id"] as! Int
        let name = rawUser["name"] as! String
        let username = rawUser["username"] as! String
        let email = rawUser["email"] as! String
        let rawAddress = rawUser["address"] as? [String: AnyObject]
        let phone = rawUser["phone"] as! String
        let website = rawUser["website"] as! String
        let rawCompany = rawUser["company"] as! [String: String]
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            let userIDPredicate = NSPredicate(format: "userID == %d", userID)
            
            appDelegate.dataManager.fetch("User", predicate: userIDPredicate, completionHandler: { (results) -> () in
                if let results = results as? [User]
                {
                    if let user = (results.first != nil) ? results.first : appDelegate.dataManager.insertEntity("User") as? User
                    {
                        user.userID = Int64(userID)
                        user.name = name
                        user.username = username
                        user.email = email
                        user.phone = phone
                        user.website = website
                        
                        Address.parseAddress(rawAddress!, completionHandler: { (address) -> () in
                            user.address = NSSet(object: address)
                        })
                        
                        Company.parseCompany(rawCompany, completionHandler: { (company) -> () in
                            user.company = NSSet(object: company)
                        })
                        
                        appDelegate.dataManager.save()
                        
                        completionHandler(user: user)
                    }
                }
            })
        }
    }
}
