//
//  ListsTableViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class ListsTableViewController: CoreDataTableViewController {

    @IBAction func addAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Add List", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "List Title"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .Default) { (action) in
            if let textField = alert.textFields?.first as? UITextField,
                let title = textField.text {
                    if let list = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: self.controller.managedObjectContext) as? List {
                        list.title = title
                        list.managedObjectContext?.save(nil)
                    }
            }
        })
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        request = NSFetchRequest(entityName: "List")
        request.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let list = controller.objectAtIndexPath(indexPath) as? List {
            cell.textLabel?.text = list.title
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .ShortStyle
            cell.detailTextLabel?.text = formatter.stringFromDate(list.timestamp)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! UITableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return false
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let itemsViewController = segue.destinationViewController as? ItemsTableViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPathForCell(cell),
            let list = controller.objectAtIndexPath(indexPath) as? List {
                itemsViewController.list = list
        }
    }

}
