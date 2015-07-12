//
//  FavItem.swift
//  Checklist
//
//  Created by Remus Lazar on 12.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import Foundation
import CoreData

@objc(FavItem)
class FavItem: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var timestamp: NSDate

    override func awakeFromInsert() {
        super.awakeFromInsert()
        timestamp = NSDate()
    }
    
    class func addItem(#title: String, inManagerObjectContext moc: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: "FavItem")
        request.predicate = NSPredicate(format: "title = %@", argumentArray: [title])
        if let result = moc.executeFetchRequest(request, error: nil),
            let item = result.first as? FavItem {
                item.timestamp = NSDate()
        } else {
            if let item = NSEntityDescription.insertNewObjectForEntityForName("FavItem", inManagedObjectContext: moc) as? FavItem {
                item.title = title
            }
        }
    }
}
