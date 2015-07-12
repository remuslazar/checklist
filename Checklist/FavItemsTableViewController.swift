//
//  FavItemsTableViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 12.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class FavItemsTableViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        request = NSFetchRequest(entityName: "FavItem")
        request.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        super.viewDidLoad()
    }
    
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let list = controller.objectAtIndexPath(indexPath) as? FavItem {
            cell.textLabel?.text = list.title
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavItemCell", forIndexPath: indexPath) as! UITableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
}
