//
//  Address.swift
//  CoreDataSample
//
//  Created by Ricardo Michel Reyes Martínez on 11/28/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Address: NSManagedObject
{
    class func parseAddress(rawAddress: [String: AnyObject], completionHandler: (address: Address) -> ())
    {
        let street = rawAddress["street"] as! String
        let suite = rawAddress["suite"] as! String
        let city = rawAddress["city"] as! String
        let zipcode = rawAddress["zipcode"] as! String
        
        let rawGeo = rawAddress["geo"] as! [String: String]
        let latitude = Double(rawGeo["lat"]!)
        let longitude = Double(rawGeo["lng"]!)
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            let companyPredicate = NSPredicate(format: "latitude == %f && longitude == %f", latitude!, longitude!)
            
            appDelegate.dataManager.fetch("Address", predicate: companyPredicate, completionHandler: { (results) -> () in
                if let results = results as? [Address]
                {
                    if let address = (results.first != nil) ? results.first : appDelegate.dataManager.insertEntity("Address") as? Address
                    {
                        address.street = street
                        address.suite = suite
                        address.city = city
                        address.zipcode = zipcode
                        address.latitude = latitude!
                        address.longitude = longitude!
                        
                        appDelegate.dataManager.save()
                        completionHandler(address: address)
                    }
                }
            })
        }
    }
}