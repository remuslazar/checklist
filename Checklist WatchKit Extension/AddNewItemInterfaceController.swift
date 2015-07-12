//
//  AddNewItemInterfaceController.swift
//  Checklist
//
//  Created by Remus Lazar on 12.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class AddNewItemInterfaceController: WKInterfaceController {
    
    var list: List!
    var itemTitle: String! { didSet { newItemTitleLAbel.setText(itemTitle) } }
    
    var quantity:Float = 1.0 {
        didSet {
            quantityLabel.setText(NSNumberFormatter().stringFromNumber(NSNumber(float: quantity)))
        }
    }
    
    @IBOutlet weak var quantityLabel: WKInterfaceLabel!
    @IBOutlet weak var newItemTitleLAbel: WKInterfaceLabel!
    @IBAction func stepper(value: Float) { quantity = value }
    
    private func getItemTitle() {
        let suggestions = [ "Beer", "Milk", "Bread"]
        presentTextInputControllerWithSuggestions(suggestions, allowedInputMode: .Plain) { (results) -> Void in
            if let input = results.first as? String {
                self.itemTitle = input
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.list = context as! List
        if itemTitle == nil { getItemTitle() }
    }

//    override func willActivate() {
//        // This method is called when watch view controller is about to be visible to user
//        super.willActivate()
//    }
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//        super.didDeactivate()
//    }
    
    @IBAction func add() {
        if let newItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: self.list.managedObjectContext!) as? Item {
            newItem.title = itemTitle
            newItem.quantity = quantity
            self.list.mutableOrderedSetValueForKey("items").insertObject(newItem, atIndex: self.list.items.count)
            self.list.managedObjectContext?.save(nil)
            self.dismissController()
        }
        
    }
    
    @IBAction func editTitle() {
        getItemTitle()
    }
    
}
