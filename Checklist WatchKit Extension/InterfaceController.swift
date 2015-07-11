//
//  InterfaceController.swift
//  Checklist WatchKit Extension
//
//  Created by Remus Lazar on 10.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    @IBOutlet weak var table: WKInterfaceTable!

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        table.setNumberOfRows(3, withRowType: "Items")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
