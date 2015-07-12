//
//  ItemsInterfaceController.swift
//  Checklist
//
//  Created by Remus Lazar on 11.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class ItemsInterfaceController: WKInterfaceController {
    
    var list: List!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let list = context as? List {
            self.list = list
            setTitle(list.title)
        }
    }

    @IBOutlet weak var table: WKInterfaceTable!
    
    @IBAction func deleteLast() {
        list.managedObjectContext?.deleteObject(self.list.items.lastObject as! Item)
        list.managedObjectContext?.save(nil)
        reloadTable()
    }
    
    @IBAction func addNew() {
        self.presentControllerWithName("Add New", context: list)
    }
    
    private func configureCellAtIndex(index: Int, item: Item) {
        if let cell = table.rowControllerAtIndex(index) as? ItemRowType {
            cell.titleLabel.setText(item.title)
            cell.quantityLabel.setText(NSNumberFormatter().stringFromNumber(item.quantity))
            cell.titleLabel.setAttributedText(NSAttributedString(string: item.title, attributes: [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
                NSStrikethroughStyleAttributeName: item.purchased,
                NSForegroundColorAttributeName: item.purchased ? UIColor.darkGrayColor() : UIColor.lightTextColor()
                ]))
        }
    }
    
    private func reloadTable() {
        table.setNumberOfRows(list.items.count, withRowType: "Items")
        for (index, item) in enumerate(list.items) {
            configureCellAtIndex(index, item: item as! Item)
        }
        setTitle("\(list.items.count) Item(s)")
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if let item = list.items[rowIndex] as? Item {
            item.purchased = !item.purchased
            configureCellAtIndex(rowIndex, item: item)
            item.managedObjectContext?.save(nil)
        }
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
