//
//  NewItemViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class NewItemViewController: UIViewController {

    // MARK: - public API
    var item: Item!
    var list: List!
    
    // MARK: - private data

    private var itemDescription = ""
    private var itemQuantity = 1.0 { didSet { stepper?.value = itemQuantity } }
    
    private func updateUI() {
        descriptionInputField?.text = itemDescription
        quantityInputField?.text = NSNumberFormatter().stringFromNumber(NSNumber(double: itemQuantity))
    }

    private func save() {
        if item == nil { // insert a new record
            if let moc = list.managedObjectContext {
                item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: moc) as! Item
                let items = list.mutableOrderedSetValueForKey("items")
                items.insertObject(item, atIndex: 0)
            }
        }
        item.title = itemDescription
        item.quantity = Float(itemQuantity)
        item.managedObjectContext?.save(nil)
    }
    
    // MARK: - Outlets
    @IBAction func inputFieldsUpdate() {
        itemDescription = descriptionInputField.text
        itemQuantity = NSNumberFormatter().numberFromString(quantityInputField.text)?.doubleValue ?? 1.0
        updateUI()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        descriptionInputField.resignFirstResponder()
        save()
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var quantityInputField: UITextField!
    @IBOutlet weak var descriptionInputField: UITextField!
    @IBOutlet weak var stepper: UIStepper! { didSet { stepper.value = itemQuantity } }
    @IBAction func stepQuantity(sender: UIStepper) {
        itemQuantity = sender.value
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            itemDescription = item.title
            itemQuantity = Double(item.quantity)
        }
        updateUI()
    }
    
}
