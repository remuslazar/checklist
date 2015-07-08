//
//  Item.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var sorting: NSNumber
    @NSManaged var timestamp: NSDate
    
    override func awakeFromInsert() {
        timestamp = NSDate()
    }

}
