//
//  InterfaceController.swift
//  Checklist WatchKit Extension
//
//  Created by Remus Lazar on 10.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import WatchKit
import Foundation
import ChecklistKit
import CoreData


class InterfaceController: WKInterfaceController, NSFetchedResultsControllerDelegate {

    var firstLaunch = true
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    let data = DataAccess()
    
    lazy var controller: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "List")
        request.sortDescriptors = [ NSSortDescriptor(key: "timestamp", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.data.managedObjectContext!,
            sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    private func reloadTable() {
        let rowCount = controller.sections!.first!.numberOfObjects
        table.setNumberOfRows(rowCount, withRowType: "Lists")
        for var i=0; i<table.numberOfRows; i++ {
            let row = table.rowControllerAtIndex(i) as! MainRowType
            let list = controller.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! List
            row.rowDescription.setText(list.title)
            row.itemCountLabel.setText(NSNumberFormatter().stringFromNumber(NSNumber(integer: list.items.count)))
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        reloadTable()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        controller.delegate = self
        controller.performFetch(nil)
        
        if (firstLaunch) {
            firstLaunch = false
            if let count = controller.sections?.first?.numberOfObjects where count == 1,
                let list = controller.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? List {
                    pushControllerWithName("Items", context: list)
            }
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if let list = controller.objectAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: 0)) as? List {
            return list
        }
        return nil
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        reloadTable()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
