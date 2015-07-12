//
//  FavItemsTableViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 12.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

protocol FavItemsTableDelegate: class {
    func favItemsdidSelectitemWithTitle(title: String)
}

class FavItemsTableViewController: CoreDataTableViewController {

    weak var delegate: FavItemsTableDelegate?
    
    // MARK: - public API
    var list: List? // optionally filter only fav items for the selected list
    
    override func viewDidLoad() {
        request = NSFetchRequest(entityName: "FavItem")
        request.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        if let items = list?.items.array as? [Item] {
            request.predicate = NSCompoundPredicate(
                type: .NotPredicateType,
                subpredicates: [
                    NSPredicate(format: "title IN %@", argumentArray: [items.map { $0.title }])
                ])
        }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let favItem = controller.objectAtIndexPath(indexPath) as? FavItem {
            delegate?.favItemsdidSelectitemWithTitle(favItem.title)
        }
    }
}
