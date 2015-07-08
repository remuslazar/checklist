//
//  ItemsTableViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: CoreDataTableViewController {

    // MARK: - Outlets
    @IBAction func addItem(sender: AnyObject) {
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: controller.managedObjectContext) as! Item
        
        let total = controller.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Item"), error: nil)
        
        item.title = "My Item # \(total)"
        item.sorting = total
        
        controller.managedObjectContext.save(nil)
    }
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButton(sender: UIBarButtonItem) { inEditMode = !inEditMode }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        request = NSFetchRequest(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "sorting", ascending: false)]
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let item = controller.objectAtIndexPath(indexPath) as? Item {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.timestamp)"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell
        
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
