//
//  Company.swift
//  CoreDataSample
//
//  Created by Ricardo Michel Reyes Martínez on 11/28/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Company: NSManagedObject
{
    class func parseCompany(rawCompany: [String: String], completionHandler: (company: Company) -> ())
    {
        let name = rawCompany["name"]
        let catchphrase = rawCompany["catchPhrase"]
        let bs = rawCompany["bs"]
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            let companyPredicate = NSPredicate(format: "name == %@", name!)
            
            appDelegate.dataManager.fetch("Company", predicate: companyPredicate, completionHandler: { (results) -> () in
                if let results = results as? [Company]
                {
                    if let company = (results.first != nil) ? results.first : appDelegate.dataManager.insertEntity("Company") as? Company
                    {
                        company.name = name
                        company.catchphrase = catchphrase
                        company.bs = bs
                        
                        appDelegate.dataManager.save()
                        completionHandler(company: company)
                    }
                }
            })
        }
    }
}
