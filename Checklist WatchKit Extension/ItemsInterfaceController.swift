//
//  ItemsInterfaceController.swift
//  Checklist
//
//  Created by Remus Lazar on 11.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import WatchKit
import Foundation


class ItemsInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let list = context as? List {
            table.setNumberOfRows(list.items.count, withRowType: "Items")
            for (index, item) in enumerate(list.items) {
                if let item = item as? Item,
                    cell = table.rowControllerAtIndex(index) as? ItemRowType {
                        cell.titleLabel.setText(item.title)
                        cell.quantityLabel.setText(NSNumberFormatter().stringFromNumber(item.quantity))
                }
            }
        }
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
