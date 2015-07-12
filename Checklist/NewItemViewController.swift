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
    private var itemQuantity = 1.0 { didSet { stepper?.value = itemQuantity } }
    
    private func updateUI() {
        descriptionInputField?.text = itemDescription
        quantityInputField?.text = NSNumberFormatter().stringFromNumber(NSNumber(double: itemQuantity))
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
        itemQuantity = NSNumberFormatter().numberFromString(quantityInputField.text)?.doubleValue ?? 1.0
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
    @IBOutlet weak var stepper: UIStepper! { didSet { stepper.value = itemQuantity } }
    @IBAction func stepQuantity(sender: UIStepper) {
        itemQuantity = sender.value
        updateUI()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            itemDescription = item.title
            itemQuantity = Double(item.quantity)
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
