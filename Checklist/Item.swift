//
//  Item.swift
//  Checklist
//
//  Created by Remus Lazar on 09.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
class Item: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var quantity: NSNumber
    @NSManaged var purchased: Bool
    @NSManaged var list: List
    @NSManaged var timestamp: NSDate
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        timestamp = NSDate()
    }
    

}
