//
//  ItemsTableViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Outlets
    @IBAction func addItem(sender: AnyObject) {
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: itemController.managedObjectContext) as! Item
        
        let total = itemController.managedObjectContext.countForFetchRequest(NSFetchRequest(entityName: "Item"), error: nil)
        
        item.title = "My Item # \(total)"
        item.sorting = total
        
        itemController.managedObjectContext.save(nil)
    }
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButton(sender: UIBarButtonItem) { inEditMode = !inEditMode }
    
    // MARK: - private vars
    private lazy var itemController: NSFetchedResultsController = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request = NSFetchRequest(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "sorting", ascending: false)]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        }()

    private var inEditMode = false {
        didSet {
            tableView.editing = inEditMode
            // change the edit/done button accordingly
            let newButton = UIBarButtonItem(barButtonSystemItem: inEditMode ? .Done : .Edit, target: self, action: "editButton:")
            navigationItem.leftBarButtonItem = newButton
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        itemController.delegate = self
        itemController.performFetch(nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return itemController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let sectionInfo: AnyObject = itemController.sections![section]
        return sectionInfo.numberOfObjects
    }

    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let item = itemController.objectAtIndexPath(indexPath) as? Item {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.timestamp)"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        configureCell(cell, atIndexPath: indexPath)
        return cell
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
            if let item = itemController.objectAtIndexPath(indexPath) as? Item {
                itemController.managedObjectContext.deleteObject(item)
                itemController.managedObjectContext.save(nil)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if let item1 = itemController.objectAtIndexPath(fromIndexPath) as? Item,
            let item2 = itemController.objectAtIndexPath(toIndexPath) as? Item {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
