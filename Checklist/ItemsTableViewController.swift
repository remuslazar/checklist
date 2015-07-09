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

    // MARK: - public API
    
    var list: List! // selected list from the parent VC
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        request = NSFetchRequest(entityName: "Item")
        request.predicate = NSPredicate(format: "list = %@", list)
        request.sortDescriptors = [
            NSSortDescriptor(key: "purchased", ascending: true),
            NSSortDescriptor(key: "sorting", ascending: false)
        ]
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let item = controller.objectAtIndexPath(indexPath) as? Item {
            cell.detailTextLabel?.text = NSNumberFormatter().stringFromNumber(item.quantity)
            cell.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
                NSStrikethroughStyleAttributeName: item.purchased,
                NSForegroundColorAttributeName: item.isPurchased ? UIColor.lightGrayColor() : UIColor.darkTextColor()
                ])
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! UITableViewCell
        
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !tableView.editing {
            if let item = controller.objectAtIndexPath(indexPath) as? Item {
                item.purchased = !item.isPurchased
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
                let item = controller.objectAtIndexPath(indexPath) as? Item {
                    editItemVC.title = "Edit Item"
                    editItemVC.item = item
            }
            editItemVC.list = list
        }
    }

}
