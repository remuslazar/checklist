//
//  Checklist.swift
//  Checklist
//
//  Created by Remus Lazar on 12.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import Foundation
import CoreData
import ChecklistKit

class Checklist {
    let moc = DataAccess.sharedInstance.managedObjectContext!
    
    // returns all the fav items, optionally not already contained in the list
    func favItems(forList list: List!) -> [FavItem] {
        let request = NSFetchRequest(entityName: "FavItem")
        request.sortDescriptors = [ NSSortDescriptor(key: "timestamp", ascending: false)]
        
        if let results = moc.executeFetchRequest(request, error: nil) as? [FavItem] {
            if list == nil { return results }
            
            // filter only the favs not in list.items
            if let itemsArray = list.items.array as? [Item] {
                let titlesInList = itemsArray.map { $0.title }
                return results.filter { !contains(titlesInList, $0.title) }
            }
        }
        return []
    }
    
    func addItem(#title: String, quantity: Double?, toList list: List) {
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: moc) as! Item
        let items = list.mutableOrderedSetValueForKey("items")
        items.insertObject(item, atIndex: items.count)
        updateItem(item, title: title, quantity: quantity)
    }
    
    func updateItem(item: Item, title: String, quantity: Double?) {
        item.title = title
        item.quantity = quantity
        FavItem.addItem(title: title, inManagerObjectContext: moc)
        moc.save(nil)
    }
    
}
