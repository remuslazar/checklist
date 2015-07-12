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
    
    private var suggestions: [String] {
        return Checklist().favItems(forList: list).map { $0.title }
    }
    
    private func getItemTitle() {
        presentTextInputControllerWithSuggestions(suggestions, allowedInputMode: .Plain) { (results) -> Void in
            if let input = results?.first as? String {
                self.itemTitle = input
            } else {
                self.dismissController()
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
        Checklist().addItem(title: itemTitle, quantity: Double(quantity), toList: list)
        self.dismissController()
    }
    
    @IBAction func editTitle() {
        getItemTitle()
    }
    
}
