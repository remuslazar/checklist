//
//  ItemsTableViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController {

    // MARK: - public API
    
    var list: List! // selected list from the parent VC

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let item = list.items[indexPath.row] as? Item {
            cell.detailTextLabel?.text = NSNumberFormatter().stringFromNumber(item.quantity)
            cell.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
                NSStrikethroughStyleAttributeName: item.purchased,
                NSForegroundColorAttributeName: item.purchased ? UIColor.lightGrayColor() : UIColor.darkTextColor()
                ])
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if let item = list.items[fromIndexPath.row] as? Item {
            list.mutableOrderedSetValueForKey("items").moveObjectsAtIndexes(
                NSIndexSet(index: fromIndexPath.row),
                toIndex: toIndexPath.row
            )
        }
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if let item = list.items[indexPath.row] as? Item {
                item.managedObjectContext?.deleteObject(item)
                item.managedObjectContext?.save(nil)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !tableView.editing {
            if let item = list.items[indexPath.row] as? Item {
                item.purchased = !item.purchased
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let editItemVC = segue.destinationViewController as? NewItemViewController {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell),
                let item = list.items[indexPath.row] as? Item {
                    editItemVC.title = "Edit Item"
                    editItemVC.item = item
            }
            editItemVC.list = list
        }
    }

}
