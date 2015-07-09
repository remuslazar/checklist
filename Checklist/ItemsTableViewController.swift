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
    
    var list: List! { // selected list from the parent VC
        didSet { list.addObserver(self, forKeyPath: "items", options: nil, context: nil) }
    }

    deinit {
        if list != nil { list.removeObserver(self, forKeyPath: "items") }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
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
//                tableView.reloadData()
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
