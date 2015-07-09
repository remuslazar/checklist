//
//  List.swift
//  Checklist
//
//  Created by Remus Lazar on 08.07.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import Foundation
import CoreData

class List: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var timestamp: NSDate
    @NSManaged var items: NSOrderedSet

    override func awakeFromInsert() {
        super.awakeFromInsert()
        timestamp = NSDate()
    }

}
