//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Ricardo Michel Reyes Martínez on 11/28/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        User.getUsers { (user) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.reloadUsers()
            })
        }
        
        let request = NSFetchRequest(entityName: "User")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
            
            reloadUsers()
        }
    }
    
    func reloadUsers()
    {
        do
        {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
            
        catch
        {
            print("Fetch results controller failed")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let user = fetchedResultsController?.objectAtIndexPath(indexPath) as? User
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell")!
        
        cell.textLabel?.text = user?.name
        cell.detailTextLabel?.text = user?.email
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if let sections = fetchedResultsController?.sections
        {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = fetchedResultsController?.sections
        {
            let section = sections[section]
            return section.numberOfObjects
        }
        
        return 0
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

