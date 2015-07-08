//
//  CoreDataTableViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var request: NSFetchRequest!
    
    lazy var controller: NSFetchedResultsController = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: appDelegate.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        }()

    var inEditMode = false {
        didSet {
            tableView.editing = inEditMode
            // change the edit/done button accordingly
            let newButton = UIBarButtonItem(barButtonSystemItem: inEditMode ? .Done : .Edit, target: self, action: "editButton:")
            navigationItem.leftBarButtonItem = newButton
        }
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        // implemented by subclass
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if request != nil {
            controller.delegate = self
            controller.performFetch(nil)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if let item = controller.objectAtIndexPath(indexPath) as? Item {
                controller.managedObjectContext.deleteObject(item)
                controller.managedObjectContext.save(nil)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if let item1 = controller.objectAtIndexPath(fromIndexPath) as? Item,
            let item2 = controller.objectAtIndexPath(toIndexPath) as? Item {
                let tmp = item2.sorting
                item2.sorting = item1.sorting
                item1.sorting = tmp
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return controller.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let sectionInfo: AnyObject = controller.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let indexPath = indexPath,
                let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    configureCell(cell, atIndexPath: indexPath)
            }
        case .Move:
            if let from = indexPath,
                let to = newIndexPath {
                    tableView.deleteRowsAtIndexPaths([from], withRowAnimation: .Fade)
                    tableView.insertRowsAtIndexPaths([to], withRowAnimation: .Fade)
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}
