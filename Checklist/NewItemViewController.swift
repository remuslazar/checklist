//
//  NewItemViewController.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import CoreData

class NewItemViewController: UIViewController, FavItemsTableDelegate, UITextFieldDelegate {

    // MARK: - public API
    var item: Item!
    var list: List!
    
    // MARK: - private data

    private var itemDescription = ""
    private var itemQuantity: Double? {
        didSet {
            if itemQuantity == 0 { itemQuantity = nil }
            stepper?.value = itemQuantity ?? 0
        }
    }
    
    private func updateUI() {
        descriptionInputField?.text = itemDescription
        quantityInputField?.text = itemQuantity != nil ? NSNumberFormatter().stringFromNumber(NSNumber(double: itemQuantity!)) : nil
    }

    private func save() {
        let title = itemDescription.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        let checklist = Checklist()
        if item == nil { // insert a new record
            checklist.addItem(title: title, quantity: itemQuantity, toList: list)
        } else {
            checklist.updateItem(item, title: title, quantity: itemQuantity)
        }
    }
    
    // MARK: - Outlets
    @IBAction func inputFieldsUpdate() {
        itemDescription = descriptionInputField.text
        itemQuantity = NSNumberFormatter().numberFromString(quantityInputField.text)?.doubleValue
        updateUI()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        descriptionInputField.resignFirstResponder()
        save()
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var quantityInputField: UITextField!
    @IBOutlet weak var descriptionInputField: UITextField! {
        didSet {
            descriptionInputField.delegate = self
        }
    }
    @IBOutlet weak var stepper: UIStepper! { didSet { stepper.value = itemQuantity ?? 0 } }
    @IBAction func stepQuantity(sender: UIStepper) {
        itemQuantity = sender.value
        updateUI()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        save()
        navigationController?.popViewControllerAnimated(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            itemDescription = item.title
            itemQuantity = item.quantity != nil ? Double(item.quantity!) : nil
        }
        updateUI()
        descriptionInputField.becomeFirstResponder()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let favItemsTVC = segue.destinationViewController as? FavItemsTableViewController {
            // embed segue, setup delegate
            favItemsTVC.delegate = self
            favItemsTVC.list = list
        }
    }
    
    func favItemsdidSelectitemWithTitle(title: String) {
        itemDescription = title
        updateUI()
        descriptionInputField.resignFirstResponder()
    }
    
}
